require 'local_acme'

class Certificate < ApplicationRecord
  include Filterable

  scope :cn, -> (cn) { where cn: cn }
  scope :acme_id, -> (acme_id) { where acme_id: acme_id }
  scope :starts_with, -> (cn) { where('cn like ?', "#{cn}%")}
  scope :contains, -> (cn) { where('cn like ?', "%#{cn}%")}

  #attr_accessor :cn, :last_crt, :csr, :key, :detail, :acme_id, :owner
  validates :cn, :owner, presence: true
  before_create :acme_request

  belongs_to :owner

  private
  def acme_request
    LocalAcme.instance.request_cert(self)
  end
end
