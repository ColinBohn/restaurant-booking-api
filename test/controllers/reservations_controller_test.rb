require 'test_helper'

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  test 'check should return restaurants' do
    get check_reservations_url, params: { time: '2024-01-01T12:00:00Z', users: ['Colin'] }
    assert_response :success
    assert_equal 2, @response.parsed_body.count
  end

  test "check should filter by users' combined dietary preferences" do
    # No restrictions
    get check_reservations_url, params: { time: '2024-01-01T12:00:00Z', users: ['Colin'] }
    assert_equal 2, @response.parsed_body.length

    # Vegan
    get check_reservations_url, params: { time: '2024-01-01T12:00:00Z', users: ['Bryson'] }
    assert_equal 1, @response.parsed_body.length

    # Vegan
    get check_reservations_url, params: { time: '2024-01-01T12:00:00Z', users: %w[Bryson Colin] }
    assert_equal 1, @response.parsed_body.length

    # Vegan and Gluten Free
    get check_reservations_url, params: { time: '2024-01-01T12:00:00Z', users: %w[Bryson Yasmine] }
    assert_equal 0, @response.parsed_body.length
  end

  test 'check should filter by table capacity' do
    # One 2-person table, one 4-person table
    get check_reservations_url, params: { time: '2024-01-01T12:00:00Z', users: %w[Colin Harold Yasmine] }
    assert_equal 1, @response.parsed_body.length

    restaurant_tables(:mcd_4).destroy

    get check_reservations_url, params: { time: '2024-01-01T12:00:00Z', users: %w[Colin Harold Yasmine] }
    assert_equal 0, @response.parsed_body.length
  end

  test 'check should filter by table availability' do
    # Both restaurants available
    get check_reservations_url, params: { time: '2024-01-01T12:00:00Z', users: ['Colin'] }
    assert_equal 2, @response.parsed_body.length

    Reservation.create!(restaurant_table: restaurant_tables(:bk_2), users: [users(:yasmine)],
                        time: '2024-01-01T12:00:00Z')

    # Only McDs available
    get check_reservations_url, params: { time: '2024-01-01T12:00:00Z', users: %w[Colin Harold Yasmine] }
    assert_equal 1, @response.parsed_body.length
    assert_equal 'McDonalds', @response.parsed_body.first['name']
  end

  test 'create should create a reservation' do
    assert_difference 'Reservation.count' do
      post reservations_url,
           params: { restaurant_id: restaurants(:mcd).id, users: ['Colin'], time: '2024-01-01T12:00:00Z' }
    end

    assert_response :created
  end

  test 'create should not overbook a table' do
    Reservation.create(restaurant_table: restaurant_tables(:bk_2), users: [users(:harold)],
                       time: '2024-01-01T10:30:00Z')

    assert_no_difference 'Reservation.count' do
      post reservations_url,
           params: { restaurant_id: restaurants(:bk).id, users: ['Colin'], time: '2024-01-01T12:00:00Z' }
    end

    assert_response :bad_request
  end

  test 'create should not overbook a person' do
    Reservation.create(restaurant_table: restaurant_tables(:bk_2), users: [users(:harold)],
                       time: '2024-01-01T10:30:00Z')

    assert_no_difference 'Reservation.count' do
      post reservations_url,
           params: { restaurant_id: restaurants(:mcd).id, users: ['Harold'], time: '2024-01-01T12:00:00Z' }
    end

    assert_response :bad_request
  end

  test 'create should reserve the lowest capacity table' do
    # 2 person table is booked first
    post reservations_url,
         params: { restaurant_id: restaurants(:mcd).id, users: ['Colin'], time: '2024-01-01T12:00:00Z' }

    assert_equal restaurant_tables(:mcd_2).id, @response.parsed_body['restaurant_table_id']

    # 4 person table is booked second
    post reservations_url,
         params: { restaurant_id: restaurants(:mcd).id, users: ['Harold'], time: '2024-01-01T12:00:00Z' }

    assert_equal restaurant_tables(:mcd_4).id, @response.parsed_body['restaurant_table_id']
  end

  test 'destroy should delete a reservation' do
    res = Reservation.create!(restaurant_table: restaurant_tables(:bk_2), users: [users(:yasmine)],
                              time: '2024-01-01T12:00:00Z')

    assert_difference 'Reservation.count', -1 do
      delete reservation_url(res.id)
    end
    assert_response :success
  end
end
