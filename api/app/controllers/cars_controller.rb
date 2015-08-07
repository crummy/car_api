class CarsController < ApplicationController

  def index
    begin
      params.require(:location)
      latitude, longitude = params['location'].split(",")
      latitude = latitude.to_f
      longitude = longitude.to_f
      unless (-180..180).include? latitude and (-90..90).include? longitude
        raise RangeError
      end
      render json: {"cars" => cars_near(latitude, longitude)}, except: [:id, :created_at, :updated_at]
  
    rescue ActionController::ParameterMissing => error
      render json: {"error" => "Missing parameters: #{error}"}, status: :bad_request

    rescue RangeError
      render json: {"error" => "Parameters out of range"}, status: :bad_request
    
    end

  end

  def not_found
    render json: {"error" => "Not found"}, status: :not_found
  end

  private
    def cars_near(lat, lon, count=10)
      searchRadius = 0.01
      maxRadius = 30
      nearestCars = []
      while nearestCars.length < count and searchRadius < maxRadius do
        # [] + to convert to an array, to allow for in-place sort_by later
        nearestCars = [] + Car.where(latitude: (lat-searchRadius..lat+searchRadius), longitude: (lon-searchRadius..lon+searchRadius))
        searchRadius *= 2
      end
      nearestCars.sort_by! do |car|
        distance_between(car[:latitude], car[:longitude], lat, lon)
      end
      return nearestCars[0..count-1]
    end

    def distance_between(x1, y1, x2, y2)
      Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
    end

end
