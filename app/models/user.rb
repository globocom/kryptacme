class User < ApplicationRecord
  include Filterable

  enum role: {register: 0, read: 1, write: 2 , admin: 3}

  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :register
  end

  scope :email, -> (email) { where email: email }
  scope :starts_with, -> (email) { where('email like ?', "#{email}%")}
  scope :contains, -> (email) { where('email like ?', "%#{email}%")}

  validates :email  , presence: true

  devise :database_authenticatable, :registerable
  has_and_belongs_to_many :projects
end
