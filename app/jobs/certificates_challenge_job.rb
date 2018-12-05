require 'local_acme'

class CertificatesChallengeJob < ApplicationJob

  def perform(certificate, authorization_uri, token, attempts, order)
    begin
      LocalAcme.instance.challenge(certificate, authorization_uri, token, attempts, order)
    rescue => e
      puts e.message
      puts e.backtrace.join("\n")
      logger.warn "Unable to challenge certificate: #{e}"
      certificate.status_detail = e.message
      certificate.error!
    end
  end
end
