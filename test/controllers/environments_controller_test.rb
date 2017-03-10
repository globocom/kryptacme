require 'test_helper'

class EnvironmentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @environment = environments(:one)
    @environment_delete = environments(:two)
    sign_in users(:one)
  end

  test "should get index" do
    get environments_url
    assert_response :success
  end

  test "should create environment" do
    assert_difference('Environment.count') do
      post environments_url, params: { environment: { destination_crt: @environment.destination_crt, name: @environment.name } }
    end

    assert_response 201
  end

  test "should show environment" do
    get environment_url(@environment)
    assert_response :success
  end

  test "should update environment" do
    patch environment_url(@environment), params: { environment: { destination_crt: @environment.destination_crt, name: @environment.name } }
    assert_response 200
  end

  test "should destroy environment" do
    assert_difference('Environment.count', -1) do
      delete environment_url(@environment_delete)
    end

    assert_response 204
  end
end
