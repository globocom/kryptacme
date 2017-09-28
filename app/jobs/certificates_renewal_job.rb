require 'local_acme'
require 'sidekiq-cron'

class CertificatesRenewalJob
  include Sidekiq::Worker

  def perform
    begin
      certificates = Certificate.where(status: [:valid_rec, :error])
      certificates.each do |cert|
        begin
          if cert.last_crt.nil?
            CertificatesCreateJob.perform_later cert
            next
          end
          openSSLCert = OpenSSL::X509::Certificate.new(cert.last_crt)
          timeNow = Time.now.utc.to_i
          timeCert = openSSLCert.not_after.to_i
          diffTime = timeCert - timeNow
          if diffTime < (cert.time_renewal * 60 * 60 * 24)
            if cert.auto_renewal
              CertificatesCreateJob.perform_later cert
            else
              diffTime <= 0 ? cert.expired! : cert.warning!
            end
          end
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
          logger.warn "Unable to renewal certificate: #{e}"
          cert.error!
        end
      end
    rescue => e
      puts e.message
      puts e.backtrace.join("\n")
      logger.warn "Unable to search valid certificate: #{e}"
    end
  end
end