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

    # Iteratively searches for the nearest cars to a point.
    # Begins searching a small area around the point, and gradually expands until 'count' cars are found. 
    # Limitations: If few cars are found near the desired point, will not expand search past
    # maxRadius distance away.
    def cars_near(lat, lon, count=10)

      # The initial "radius" of search (actually the distance to search in each direction).
      # Units are degrees of latitude.
      searchRadius = 0.01

      # Don't search for cars beyond this distance. Useful to prevent an infinite loop if car database
      # is empty.
      maxRadius = 30
      nearestCars = []
      while nearestCars.length <= count and searchRadius < maxRadius do
        # Define a search area by its north, south, east and west edges.
        north = lat + searchRadius
        south = lat - searchRadius
        west = lon - searchRadius
        east = lon + searchRadius

        # If the search area includes the 180th longitudinal line, then search the left and right of it separately.
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
