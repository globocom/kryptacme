require 'local_acme'

class CertificatesRenewalJob < ApplicationJob

  def perform
    begin
      certificates = Certificate.where(status: :valid_rec)
      certificates.each do |cert|
        openSSLCert = OpenSSL::X509::Certificate.new(cert.last_crt)
        timeNow = Time.now.utc.to_i
        timeCert = openSSLCert.not_after.to_i
        diffTime = timeCert - timeNow
        if diffTime < (60 * 60 * 24 * 30) # 30 days - turn configurable
          if cert.auto_renewal
            CertificatesCreateJob.perform_later cert
          else
            diffTime <= 0 ? cert.expired! : cert.warning!
          end
        end
      end
    rescue => e
      puts e.message
      puts e.backtrace.join("\n")
      logger.warn "Unable to renewal certificate: #{e}"
    end
  end
end