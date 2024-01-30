# frozen_string_literal: true

# Controller for finding available reservation times, and creating new reservations
class ReservationsController < ApplicationController
  # Finds restaurants with availability for the specified users at a given time
  def check
    params.require(%i[time users])

    restaurants = dietary_preferenced_restaurants.available_for(DateTime.parse(params[:time]), params[:users].count)

    render json: restaurants
  end

  # Creates a new reservation
  def create
    if available_table.nil?
      render json: { error: 'No table is available for the specified capacity and time.' }, status: :bad_request
      return
    end

    users = User.where(name: create_params[:users])
    reservation = Reservation.new(restaurant_table: available_table, users:, time:)

    if reservation.save
      render json: reservation, status: :created
    else
      render json: { errors: reservation.errors }, status: :bad_request
    end
  end

  # Destroys the specified reservation
  def destroy
    reservation = Reservation.find(params[:id])
    if reservation.destroy
      render status: :ok
    else
      render json: { errors: reservation.errors }, status: :bad_request
    end
  end

  private

  def create_params
    params.require(%i[restaurant_id time users])
    params.permit([:restaurant_id, :time, { users: [] }])
  end

  def dietary_preferenced_restaurants
    dietary_preferences = DietaryPreference.joins(:users).where(users: { name: params[:users] }).distinct

    if dietary_preferences.any?
      Restaurant.left_joins(:dietary_preferences)
                .where(dietary_preferences:)
                .group('restaurants.id')
                .having("COUNT(DISTINCT dietary_preferences.id) = #{dietary_preferences.count}")
    else
      Restaurant
    end
  end

  def time
    DateTime.parse(create_params[:time])
  end

  def available_table
    Restaurant.find(create_params[:restaurant_id]).available_table(capacity: create_params[:users].count, time:)
  end
end
