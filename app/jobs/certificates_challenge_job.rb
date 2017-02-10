require 'local_acme'

class CertificatesChallengeJob < ApplicationJob

  def perform(certificate, authorization_uri)
    LocalAcme.instance.challenge(certificate, authorization_uri)
    #TODO Change status to OK case success
  end
end
