# frozen_string_literal: true

# Create the reservation_users join table
class CreateReservationUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations_users, id: false, primary_key: %i[user_id reservation_id],
                                      comment: 'Users attending a reservation' do |t|
      t.references :reservation, type: :uuid, foreign_key: true
      t.references :user, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
