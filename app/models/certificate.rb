
class Certificate < ApplicationRecord
  include Filterable
  include GlobalID::Identification

  scope :cn, -> (cn) { where cn: cn }
  scope :acme_id, -> (acme_id) { where acme_id: acme_id }
  scope :starts_with, -> (cn) { where('cn like ?', "#{cn}%")}
  scope :contains, -> (cn) { where('cn like ?', "%#{cn}%")}

  #attr_accessor :cn, :last_crt, :csr, :key, :detail, :acme_id, :project
  validates :cn, :project, presence: true
  after_create :send_request

  belongs_to :project

  private
  def send_request
    CertificatesCreateJob.perform_later self
  end
end
