# frozen_string_literal: true

# A person who dines at restaurants
class User < ApplicationRecord
  has_and_belongs_to_many :reservations
  has_and_belongs_to_many :dietary_preferences
end
