# frozen_string_literal: true

# Types of diet preferences and restrictions
class DietaryPreference < ApplicationRecord
  has_and_belongs_to_many :users
  has_and_belongs_to_many :restaurants
end
