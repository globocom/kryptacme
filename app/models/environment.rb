class Environment < ApplicationRecord
  include Filterable

  scope :n, -> (name) { where name: name }
  scope :starts_with, -> (name) { where('name like ?', "#{name}%")}
  scope :contains, -> (name) { where('name like ?', "%#{name}%")}

  has_many :certificates
end
