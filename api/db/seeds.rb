# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

jsonPath = "../data.json"
data = JSON.parse(File.read(jsonPath))
data['locations'].each do |location|
  vehicleCount = location['vehicleCount'].to_i
  (0..vehicleCount).each do
    Car.create(description: location['description'], latitude: location['latitude'], longitude: location['longitude'])
  end
end