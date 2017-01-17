require 'local_acme'

class Owner < ApplicationRecord
  include Filterable

  scope :n, -> (name) { where name: name }
  scope :email, -> (email) { where email: email }
  scope :starts_with, -> (name) { where('name like ?', "#{name}%")}
  scope :contains, -> (name) { where('name like ?', "%#{name}%")}
  scope :acme_id, -> (acme_id) { where acme_id: acme_id }

  #attr_accessor :name, :email, :private_pem, :detail, :acme_id
  validates :name, :email, presence: true
  before_create :acme_register
  has_many :certificates

  private
  def acme_register
    LocalAcme.instance.register_owner(self)
  end
end
