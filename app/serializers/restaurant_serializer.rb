# frozen_string_literal: true

# Serializer for Restaurant model
class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :dietary_preferences

  def dietary_preferences
    object.dietary_preferences.map(&:name)
  end
end
