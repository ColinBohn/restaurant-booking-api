# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def create_restaurant(name, no_of_2_tables, no_of_4_tables, no_of_6_tables, preferences = [])
  r = Restaurant.create(name:)
  no_of_2_tables.times { RestaurantTable.create(restaurant: r, capacity: 2) }
  no_of_4_tables.times { RestaurantTable.create(restaurant: r, capacity: 4) }
  no_of_6_tables.times { RestaurantTable.create(restaurant: r, capacity: 6) }

  preferences.each do |preference|
    r.dietary_preferences << DietaryPreference.find_by(name: preference)
  end
  r.save!
end

def create_user(name, home_lat, home_lng, preferences = [])
  u = User.create(name:, home_lat:, home_lng:)
  preferences.each do |preference|
    u.dietary_preferences << DietaryPreference.find_by(name: preference)
  end
  u.save!
end

# Seed dietary preferences
['Gluten Free', 'Vegetarian', 'Vegan', 'Paleo'].each { |name| DietaryPreference.create(name:) }

# Seed restaurants
[
  ['Lardo', 4, 2, 1, ['Gluten Free']],
  ['Panadería Rosetta', 3, 2, 0, ['Vegetarian', 'Gluten Free']],
  ['Tetetlán', 4, 2, 1, ['Paleo', 'Gluten Free']],
  ['Falling Piano Brewing Co', 5, 5, 5, []],
  ['u.to.pi.a', 2, 0, 0, %w[Vegan Vegetarian]]
].each { |r| create_restaurant(*r) }

# Seed users
[
  ['Michael', 19.4153107, -99.1804722, ['Vegetarian']],
  ['George Michael', 19.4058242, -99.1671942, ['Vegetarian', 'Gluten Free']],
  ['Lucile', 19.3634215, -99.1769323, ['Gluten Free']],
  ['Gob', 19.3318331, -99.2078983, ['Paleo']],
  ['Tobias', 19.4384214, -99.2036906, []],
  ['Maeby', 19.4349474, -99.1419256, ['Vegan']]
].each { |u| create_user(*u) }
