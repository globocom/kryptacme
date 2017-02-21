class Environment < ApplicationRecord
  include Filterable

  has_many :certificates
end
