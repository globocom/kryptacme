require 'test_helper'

class CertificatesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @certificate_with_environment = certificates(:one)
    @certificate_without_environment = certificates(:three)
    sign_in users(:one)
  end

  test 'should get index' do
    get project_certificates_url(@certificate_with_environment.project.id)
    assert_response :success
  end

  test 'should create certificate with environment' do
    Certificate.any_instance.stubs(:send_request).returns(false)
    #assert_difference('Certificate.count') do
      post project_certificates_url(@certificate_with_environment.project.id), params: { certificate: {
          cn: "#{@certificate_with_environment.cn}.example.com",
          csr: @certificate_with_environment.csr,
          key: @certificate_with_environment.key,
          project_id: @certificate_with_environment.project_id,
          environment_id: @certificate_with_environment.environment_id} }
    #end
    assert_response 201
  end

  test 'should create certificate without environment' do
    Certificate.any_instance.stubs(:send_request).returns(false)
    #assert_difference('Certificate.count') do
    post project_certificates_url(@certificate_without_environment.project.id), params: { certificate: {
        cn: "#{@certificate_without_environment.cn}.example.com",
        csr: @certificate_without_environment.csr,
        key: @certificate_without_environment.key,
        project_id: @certificate_without_environment.project_id} }
    #end
    assert_response 201
  end

  test 'should show certificate' do
    get project_certificate_url(@certificate_with_environment.project.id, @certificate_with_environment)
    assert_response :success
  end

  test 'should update certificate' do
    CertificatesController.any_instance.stubs(:send_create_certificate).returns(false)
    certificate2 = certificates(:two)
    patch project_certificate_url(@certificate_with_environment.project.id, @certificate_with_environment), params: { certificate: {
        cn: "#{certificate2.cn}.example.com",
        csr: certificate2.csr,
        key: certificate2.key,
        project_id: certificate2.project_id,
        environment_id: certificate2.environment_id} }
    assert_response 200
  end

end
