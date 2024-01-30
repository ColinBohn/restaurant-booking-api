# frozen_string_literal: true

# Create the reservations table
class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations, id: :uuid, comment: 'Bookings for groups a restaurant table at a time' do |t|
      t.references :restaurant_table, type: :uuid, foreign_key: true
      t.timestamp :time
      t.timestamps
    end
  end
end
