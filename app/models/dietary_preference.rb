# frozen_string_literal: true

# Different types of food preferences and restrictions
class DietaryPreference < ApplicationRecord
  has_and_belongs_to_many :users
  has_and_belongs_to_many :restaurants
end
