# frozen_string_literal: true

# A reservation for a group of people a table
class Reservation < ApplicationRecord
  LENGTH = 2.hours

  belongs_to :restaurant_table
  has_and_belongs_to_many :users, dependent: :delete_all

  validates :restaurant_table, presence: true
  validates :time, presence: true
  validates :users, presence: true
  validate :time_should_not_overlap_for_table
  validate :time_should_not_overlap_for_user

  def time_should_not_overlap_for_table
    return if Reservation.where(restaurant_table:).where('time > ? AND time < ?', time - Reservation::LENGTH,
                                                         time + Reservation::LENGTH).none?

    errors.add(:time, 'cannot overlap another reservation for this restaurant\'s table')
  end

  def time_should_not_overlap_for_user # rubocop:disable Metrics/AbcSize
    conflicts = users.filter do |user|
      Reservation.joins(:users).where(users: user).where('time > ? AND time < ?', time - Reservation::LENGTH,
                                                         time + Reservation::LENGTH).exists?
    end
    return unless conflicts.any?

    errors.add(:base,
               "#{'User'.pluralize(conflicts)} #{conflicts.pluck(:name).join(', ')} " \
               "#{'has'.pluralize(conflicts)} conflicting reservation(s) for the specified time.")
  end
end
