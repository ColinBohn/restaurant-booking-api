# frozen_string_literal: true

# A table at a restaurant that may be reserved
class RestaurantTable < ApplicationRecord
  has_many :reservations
  belongs_to :restaurant
end
