require 'local_acme'

class CertificatesCreateJob < ApplicationJob

  def perform(certificate)
    begin
      certificate.pendent!
      LocalAcme.instance.request_cert(certificate)
    rescue => e
      puts e.message
      puts e.backtrace.join("\n")
      logger.warn "Unable to request certificate: #{e}"
      certificate.status_detail = e.message
      certificate.error!
    end
  end
end