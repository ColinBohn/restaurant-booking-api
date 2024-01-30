# frozen_string_literal: true

# Create dietary preferences and join tables to users and restaurants
class CreateDietaryPreferences < ActiveRecord::Migration[7.1]
  def change # rubocop:disable Metrics/MethodLength
    create_table :dietary_preferences, id: :uuid,
                                       comment: 'Types of different dietary choices and food restrictions' do |t|
      t.string :name
      t.timestamps
    end

    create_table :dietary_preferences_users, id: false, primary_key: %i[user_id dietary_preference_id],
                                             comment: 'The dietary preferences of users' do |t|
      t.references :user, type: :uuid, foreign_key: true
      t.references :dietary_preference, type: :uuid, foreign_key: true
      t.timestamps
    end

    create_table :dietary_preferences_restaurants, id: false, primary_key: %i[restaurant_id dietary_preference_id],
                                                   comment: 'The dietary preference options of restaurants' do |t|
      t.references :restaurant, type: :uuid, foreign_key: true
      t.references :dietary_preference, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
