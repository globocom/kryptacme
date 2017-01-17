require 'test_helper'

class OwnersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = owners(:one)
  end

  test 'should get index' do
    get owners_url
    assert_response :success
  end

  test 'should create owner' do
    assert_difference('Owner.count') do
      post owners_url, params: { owner: {
          acme_id:@owner.acme_id,
          detail:@owner.detail,
          email: "#{@owner.email}.com",
          name: "#{@owner.name}_test",
          private_pem: @owner.private_pem
      } }
    end

    assert_response 201
  end

  test 'should show owner' do
    get owner_url(@owner)
    assert_response :success
  end

  test 'should update owner' do
    patch owner_url(@owner), params: { owner: {
        acme_id:@owner.acme_id,
        detail:@owner.detail,
        email: "#{@owner.email}.com",
        name: "#{@owner.name}_test",
        private_pem: @owner.private_pem
    } }
    assert_response 200
  end

  test 'should destroy owner' do
    assert_difference('Owner.count', -1) do
      delete owner_url(@owner)
    end

    assert_response 204
  end
end
