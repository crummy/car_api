require 'test_helper'

class CarsControllerTest < ActionController::TestCase

  test "get index without location" do
    get :index
    assert_response :bad_request
  end

  test "get index with location" do
    get :index, location: "0,0"
    body = JSON.parse(response.body)
    assert_equal 10, body['cars'].length
    assert_response :success
  end

  test "get closest" do
    get :index, location: "10.1,4.9"
    body = JSON.parse(response.body)
    assert_equal cars(:two)['description'], body['cars'][0]['description']

    get :index, location: "20,30"
    body = JSON.parse(response.body)
    assert_equal cars(:one)['description'], body['cars'][0]['description']
  end

end
