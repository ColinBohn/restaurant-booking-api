# frozen_string_literal: true

# A restaurant with reservable tables
class Restaurant < ApplicationRecord
  has_many :restaurant_tables
  has_and_belongs_to_many :dietary_preferences

  scope :available_for, lambda { |time, capacity|
                          left_joins(restaurant_tables: :reservations)
                            .distinct
                            .where('restaurant_tables.capacity >= ?', capacity)
                            .having(
                              'count(reservations.time >= ? AND reservations.time < ?) < count(restaurant_tables.id)',
                              time - Reservation::LENGTH,
                              time + Reservation::LENGTH
                            )
                            .group('restaurants.id')
                        }

  # Returns an available table for a capacity at a time
  def available_table(capacity:, time:)
    restaurant_tables
      .left_joins(:reservations)
      .where('capacity >= ?', capacity)
      .having('count(reservations.time >= ? AND reservations.time < ?) = 0',
              time - Reservation::LENGTH, time + Reservation::LENGTH)
      .group('restaurant_tables.id')
      .order(capacity: :asc)
      .first
  end
end
