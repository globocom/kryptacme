require 'local_acme'

class Project < ApplicationRecord
  include Filterable

  scope :n, -> (name) { where name: name }
  scope :email, -> (email) { where email: email }
  scope :starts_with, -> (name) { where('name like ?', "#{name}%")}
  scope :contains, -> (name) { where('name like ?', "%#{name}%")}

  validates :name, :email, presence: true
  before_create :acme_register
  has_many :certificates
  has_and_belongs_to_many :users

  private
  def acme_register
    LocalAcme.instance.register_project(self)
  end
end
