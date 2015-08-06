class CarsController < ApplicationController

  def index
    begin
      params.require(:location)
      latitude, longitude = params['location'].split(",")
      latitude = latitude.to_f
      longitude = longitude.to_f
      render json: {"cars" => cars_near(Car.all, latitude, longitude, 10)}, except: [:id, :created_at, :updated_at]
  
    rescue ActionController::ParameterMissing => error
      render json: {"error" => "Invalid parameters: #{error}"}, status: :bad_request

    end 
  end

  def not_found
    render json: {"error" => "Not found"}, status: :not_found
  end

  private
    def cars_near(cars, latitude, longitude, count)
      nearestCars = cars.sort_by {|car| distance_between(car[:latitude], car[:longitude], latitude, longitude) }
      return nearestCars[0..count-1]
    end

    def distance_between(x1, y1, x2, y2)
      Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
    end

end
