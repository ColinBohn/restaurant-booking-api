# frozen_string_literal: true

# Create the restaurant_tables table
class CreateRestaurantTables < ActiveRecord::Migration[7.1]
  def change
    create_table :restaurant_tables, id: :uuid, comment: 'Reservable spaces within a restaurant' do |t|
      t.integer :capacity
      t.references :restaurant, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
