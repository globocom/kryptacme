require 'test_helper'

class CertificatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @certificate = certificates(:one)
  end

  test 'should get index' do
    get owner_certificates_url(@certificate.owner.id)
    assert_response :success
  end

  test 'should create certificate' do
    assert_difference('Certificate.count') do
      post owner_certificates_url(@certificate.owner.id), params: { certificate: {
          acme_id: @certificate.acme_id,
          cn: "#{@certificate.cn}.example.com",
          csr: @certificate.csr,
          detail: @certificate.detail,
          key: @certificate.key,
          last_crt: @certificate.last_crt,
          owner_id: @certificate.owner_id } }
    end
    assert_response 201
  end

  test 'should show certificate' do
    get owner_certificate_url(@certificate.owner.id, @certificate)
    assert_response :success
  end

  test 'should update certificate' do
    certificate2 = certificates(:two)
    patch owner_certificate_url(@certificate.owner.id, @certificate), params: { certificate: {
        acme_id: certificate2.acme_id,
        cn: "#{certificate2.cn}.example.com",
        csr: certificate2.csr,
        detail: certificate2.detail,
        key: certificate2.key,
        last_crt: certificate2.last_crt,
        owner_id: certificate2.owner_id } }
    assert_response 200
  end

  test 'should destroy certificate' do
    assert_difference('Certificate.count', -1) do
      delete owner_certificate_url(@certificate.owner.id, @certificate)
    end
    assert_response 204
  end
end
