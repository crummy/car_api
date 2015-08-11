require 'haversine'

class CarsController < ApplicationController

  def index
    begin
      params.require(:location)
      latitude, longitude = params['location'].split(",")
      latitude = latitude.to_f
      longitude = longitude.to_f
      unless (-90..90).include? latitude and (-180..180).include? longitude
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
        # define a search area by its north, south, east and west edges
        north = lat + searchRadius
        south = lat - searchRadius
        west = lon - searchRadius
        east = lon + searchRadius
        if west < -180 then
          nearestCars = Car.where(latitude: (south..north), longitude: (west+360..180)) + Car.where(latitude: (south..north), longitude: (-180..east))
        elsif east > 180 then
          nearestCars = Car.where(latitude: (south..north), longitude: (-180..east-360)) + Car.where(latitude: (south..north), longitude: (west..180))
        else
          nearestCars = [] + Car.where(latitude: (south..north), longitude: (west..east))
        end
        searchRadius *= 2
      end
      nearestCars.sort_by! do |car|
        Haversine.distance(car[:latitude], car[:longitude], lat, lon)
      end
      return nearestCars[0..count-1]
    end

end
