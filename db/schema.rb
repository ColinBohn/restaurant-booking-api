# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_29_211506) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dietary_preferences", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "Types of diet restrictions and choices", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dietary_preferences_restaurants", id: false, comment: "The dietary preference options of restaurants", force: :cascade do |t|
    t.uuid "restaurant_id"
    t.uuid "dietary_preference_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dietary_preference_id"], name: "index_dietary_preferences_restaurants_on_dietary_preference_id"
    t.index ["restaurant_id"], name: "index_dietary_preferences_restaurants_on_restaurant_id"
  end

  create_table "dietary_preferences_users", id: false, comment: "The dietary preferences of users", force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "dietary_preference_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dietary_preference_id"], name: "index_dietary_preferences_users_on_dietary_preference_id"
    t.index ["user_id"], name: "index_dietary_preferences_users_on_user_id"
  end

  create_table "reservations", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "Bookings for groups of users at a restaurant table", force: :cascade do |t|
    t.uuid "restaurant_table_id"
    t.datetime "time", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_table_id"], name: "index_reservations_on_restaurant_table_id"
  end

  create_table "reservations_users", id: false, comment: "Users attending a reservation", force: :cascade do |t|
    t.uuid "reservation_id"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_reservations_users_on_reservation_id"
    t.index ["user_id"], name: "index_reservations_users_on_user_id"
  end

  create_table "restaurant_tables", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "Reservable spaces within a restaurant", force: :cascade do |t|
    t.integer "capacity"
    t.uuid "restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_restaurant_tables_on_restaurant_id"
  end

  create_table "restaurants", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "Businesses with reservable tables", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "People who dine at restaurants", force: :cascade do |t|
    t.text "name"
    t.float "home_lat"
    t.float "home_lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "dietary_preferences_restaurants", "dietary_preferences"
  add_foreign_key "dietary_preferences_restaurants", "restaurants"
  add_foreign_key "dietary_preferences_users", "dietary_preferences"
  add_foreign_key "dietary_preferences_users", "users"
  add_foreign_key "reservations", "restaurant_tables"
  add_foreign_key "reservations_users", "reservations"
  add_foreign_key "reservations_users", "users"
  add_foreign_key "restaurant_tables", "restaurants"
end
