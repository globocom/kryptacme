
class Certificate < ApplicationRecord
  include Filterable
  include GlobalID::Identification

  enum status: { pendent: 0, valid_rec: 1, invalid_rec: 2, warning: 3, expired: 4, revoked: 5, error: 6 }

  scope :cn, -> (cn) { where cn: cn }
  scope :starts_with, -> (cn) { where('cn like ?', "#{cn}%")}
  scope :contains, -> (cn) { where('cn like ?', "%#{cn}%")}

  #attr_accessor :cn, :last_crt, :csr, :key, :project, status, status_detail
  validates :cn, :project_id, :csr, :key, presence: true
  after_create :send_request

  belongs_to :project
  belongs_to :environment, optional: true

  private
  def send_request
    CertificatesCreateJob.perform_later self
  end
end
