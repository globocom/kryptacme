require 'local_acme'
require 'sidekiq-cron'

class CertificatesRenewalJob
  include Sidekiq::Worker

  def perform
    begin
      certificates = Certificate.where(status: [:valid_rec, :error])
      certificates.each do |cert|
        begin
        ssl_cert = OpenSSL::X509::Certificate.new(cert.last_crt)
        time_now = Time.now.utc.to_i
        time_cert = ssl_cert.not_after.to_i
        diff_time = time_cert - time_now
        if diff_time < (cert.time_renewal * 60 * 60 * 24)
          if cert.auto_renewal
            CertificatesCreateJob.perform_later cert
          else
            diff_time <= 0 ? cert.expired! : cert.warning!
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