require 'test_helper'

class RootControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:someone), scope: :admin
  end

  # test "the truth" do
  #   assert true
  # end
end
