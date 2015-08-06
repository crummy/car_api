class CarsController < ApplicationController

  # GET /cars
  # GET /cars.json
  def index
    params.require(:location)
    latitude, longitude = params['location'].split(",")
    latitude = latitude.to_f
    longitude = longitude.to_f
    render :json => {"cars" => cars_near(Car.all, latitude, longitude, 10)}, :except => [:id, :created_at, :updated_at]
  end

  private
    def cars_near(cars, latitude, longitude, count)
      cars.sort_by do |car|
        distance_between(car[:latitude], car[:longitude], latitude, longitude)
      end
      cars[0..count]
    end

    def distance_between(x1, y1, x2, y2)
      Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
    end

end
