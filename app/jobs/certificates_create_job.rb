require 'local_acme'

class CertificatesCreateJob < ApplicationJob

  def perform(certificate)

    LocalAcme.instance.request_cert(certificate)
    # TODO change status to PENDENT, waiting for challenge, or to FAIL when case fails in letsencrypt
  end
end
