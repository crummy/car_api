# Cars API

An implementation of the Cars API project for Ally: a Rails app that hosts a database of cars with locations which exposes an API to return the nearest 10 cars to a given location.

## Instructions

To run the server locally, in development mode:

1. `cd api` - Enter the subdirectory that contains the Rails app
2. `bundle install` - Install required dependencies
  * If `bundle` is not found, `sudo gem install bundler`
  * If some gems fail to install (e.g. byebug), upgrade Ruby (tested on 2.1.6, 2.2.1)
3. `rake db:schema:load` - Generate database with cars table
4. `rake db:seed` - Seed the database with default car locations
5. `rails server` - Host the API
6. Make a GET request to [/cars?location=51.5444204,-0.22707](http://localhost:3000/cars?location=51.5444204,-0.22707) for example

To execute tests, run `rake test`.

## Technical notes

* The app uses only SQLite for portability. In a production setting I would prefer an SQL server with custom function support to perform the haversine calculation on the SQL server itself.
* With a database with very few cars, less than 10 results may be returned, as the app ceases searching more than 30 degrees away from the given point. It seems unlikely that people care about cars at that distance, however.
* A grid search is used to return cars around a given location. This is not as accurate as a haversine function, but only becomes a serious problem at the north and south poles (again, where people probably aren't search for cars).
* When seeding the database with cars, I add multiple cars for any location with vehicleCount > 1.
