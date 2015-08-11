require 'test_helper'

class CarsControllerTest < ActionController::TestCase

  test "get index without location" do
    get :index
    assert_response :bad_request
  end

  test "get index with location out of range" do
    get :index, location: "91,0"
    assert_response :bad_request
    get :index, location: "88,-181"
    assert_response :bad_request
  end

  test "get 10 cars" do
    get :index, location: "25,35"
    body = JSON.parse(response.body)
    assert_equal 10, body['cars'].length
    assert_response :success
  end

  test "get car on far side of the world" do
    get :index, location: "-1,179.99"
    body = JSON.parse(response.body)
    assert_equal cars(:thirteen)['description'], body['cars'][0]['description']

    get :index, location: "0.2,-179.9"
    body = JSON.parse(response.body)
    assert_equal cars(:thirteen)['description'], body['cars'][0]['description']
  end

  test "get closest" do
    get :index, location: "21.1,31.1"
    body = JSON.parse(response.body)
    assert_equal cars(:two)['description'], body['cars'][0]['description']

    get :index, location: "21,30"
    body = JSON.parse(response.body)
    assert_equal cars(:one)['description'], body['cars'][0]['description']
    assert_equal cars(:two)['description'], body['cars'][1]['description']
  end

end
