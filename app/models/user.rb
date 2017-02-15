class User < ApplicationRecord
  include Filterable

  scope :n, -> (name) { where name: name }
  scope :email, -> (email) { where email: email }
  scope :starts_with, -> (name) { where('name like ?', "#{name}%")}
  scope :contains, -> (name) { where('name like ?', "%#{name}%")}

  devise :ldap_authenticatable
  has_and_belongs_to_many :projects
end
