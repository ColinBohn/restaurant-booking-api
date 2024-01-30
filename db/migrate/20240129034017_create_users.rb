# frozen_string_literal: true

# Create the users table
class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid, comment: 'Persons who reserve tables at restaurants' do |t|
      t.text :name
      t.float :home_lat
      t.float :home_lng
      t.timestamps
    end
  end
end
