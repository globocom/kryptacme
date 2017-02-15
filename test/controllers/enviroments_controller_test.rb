require 'test_helper'

class EnviromentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @enviroment = enviroments(:one)
  end

  test "should get index" do
    get enviroments_url, as: :json
    assert_response :success
  end

  test "should create enviroment" do
    assert_difference('Enviroment.count') do
      post enviroments_url, params: { enviroment: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show enviroment" do
    get enviroment_url(@enviroment), as: :json
    assert_response :success
  end

  test "should update enviroment" do
    patch enviroment_url(@enviroment), params: { enviroment: {  } }, as: :json
    assert_response 200
  end

  test "should destroy enviroment" do
    assert_difference('Enviroment.count', -1) do
      delete enviroment_url(@enviroment), as: :json
    end

    assert_response 204
  end
end
