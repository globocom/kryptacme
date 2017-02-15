class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :projects, :links

  def links
    [
        {rel: 'self', href: "#{ApplicationController.hostname}/users/#{object.id}"},
        {rel: 'search', href: "#{ApplicationController.hostname}/users{?n,email,contains,starts_with}"}
    ]
  end
end
