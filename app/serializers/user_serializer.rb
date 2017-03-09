class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :role, :projects, :links

  def links
    [
        {rel: 'self', href: "#{ApplicationController.hostname}/users/#{object.id}"},
        {rel: 'search', href: "#{ApplicationController.hostname}/users{?email,contains,starts_with}"}
    ]
  end
end