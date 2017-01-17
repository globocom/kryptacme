class User  < ActiveRecord::Base
  devise :ldap_authenticatable
end
