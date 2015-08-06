json.array!(@cars) do |car|
  json.extract! car, :id, :description, :latitude, :longitude
  json.url car_url(car, format: :json)
end
