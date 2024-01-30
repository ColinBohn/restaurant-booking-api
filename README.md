# Restaurant Booking Take-Home

This project is built with Rails 7.1 running on Ruby 3.2, and includes an API for booking tables at restaurants based on users' dietary preferences.

Basic integration tests are completed for the API endpoints, however further unit testing of models would be beneficial.

## Setup
This project is configured to be developed within [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers), and deployed via Docker. 

* Install [Docker](https://www.docker.com/products/docker-desktop/).
* Install [VS Code](https://code.visualstudio.com).
* Install the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension for VS Code.
* Clone this repo and open the workspace within VS Code. You should be prompted to build the dev containers on launch.

## Database initialization
* The dev container setup is pre-configured with a Postgres server.
* To start developing right away, run `rails db:setup` to create all databases, load all schemas, and initialize with the seed data.
* To truncate the database and re-seed data, run `rails db:seed:replant`
* Refer to the [official docs](https://guides.rubyonrails.org/active_record_migrations.html#running-migrations) for more information on migrations and database setup.

## Running server
* To start the web server, run `rails server`. By default this will expose port 3000.

## Running tests
* To run the full test suite, run `rails test`.

## Important files
If you are reviewing this project and are unfamiliar with Rails, these files are where most custom logic resides:
```
app/controllers/reservations_controller.rb
app/models/dietary_preference.rb
app/models/reservation.rb
app/models/restaurant_table.rb
app/models/restaurant.rb
app/models/user.rb
app/serializers/restaurant_serializer.rb
db/migrate/20240129033955_create_restaurants.rb
db/migrate/20240129034017_create_users.rb
db/migrate/20240129034028_create_restaurant_tables.rb
db/migrate/20240129034037_create_reservations.rb
db/migrate/20240129035449_create_reservation_users.rb
db/migrate/20240129211506_create_dietary_preferences.rb
db/seeds.rb
test/controllers/reservations_controller_test.rb
test/fixtures/dietary_preferences.yml
test/fixtures/restaurant_tables.yml
test/fixtures/restaurants.yml
test/fixtures/users.yml
```