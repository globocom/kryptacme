class User < ApplicationRecord
  include Filterable

  enum role: {register: 0, read: 1, write: 2 , admin: 3}

  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :register
  end

  scope :n, -> (name) { where name: name }
  scope :email, -> (email) { where email: email }
  scope :starts_with, -> (name) { where('name like ?', "#{name}%")}
  scope :contains, -> (name) { where('name like ?', "%#{name}%")}

  devise :ldap_authenticatable
  has_and_belongs_to_many :projects
end
