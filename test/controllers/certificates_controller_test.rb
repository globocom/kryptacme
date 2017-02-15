require 'test_helper'

class CertificatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @certificate = certificates(:one)
  end

  test 'should get index' do
    get project_certificates_url(@certificate.project.id)
    assert_response :success
  end

  test 'should create certificate' do
    assert_difference('Certificate.count') do
      post project_certificates_url(@certificate.project.id), params: { certificate: {
          cn: "#{@certificate.cn}.example.com",
          csr: @certificate.csr,
          key: @certificate.key,
          last_crt: @certificate.last_crt,
          project_id: @certificate.project_id } }
    end
    assert_response 201
  end

  test 'should show certificate' do
    get project_certificate_url(@certificate.project.id, @certificate)
    assert_response :success
  end

  test 'should update certificate' do
    certificate2 = certificates(:two)
    patch project_certificate_url(@certificate.project.id, @certificate), params: { certificate: {
        cn: "#{certificate2.cn}.example.com",
        csr: certificate2.csr,
        key: certificate2.key,
        last_crt: certificate2.last_crt,
        project_id: certificate2.project_id } }
    assert_response 200
  end

  test 'should destroy certificate' do
    assert_difference('Certificate.count', -1) do
      delete project_certificate_url(@certificate.project.id, @certificate)
    end
    assert_response 204
  end
end
