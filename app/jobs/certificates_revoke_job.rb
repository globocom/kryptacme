require 'local_acme'

class CertificatesRevokeJob < ApplicationJob

  def perform(certificate)
    begin
      LocalAcme.instance.revoke_cert(certificate)
      certificate.revoked!
    rescue => e
      puts e.message
      puts e.backtrace.join("\n")
      logger.warn "Unable to revoke certificate: #{e}"
      certificate.status_detail = e.message
      certificate.error!
    end
  end
end
