# frozen_string_literal: true

# Create the restaurants table
class CreateRestaurants < ActiveRecord::Migration[7.1]
  def change
    create_table :restaurants, id: :uuid, comment: 'Businesses with reservable tables' do |t|
      t.text :name
      t.timestamps
    end
  end
end
