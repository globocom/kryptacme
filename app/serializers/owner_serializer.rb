class OwnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :detail, :acme_id, :links

  def links
    [
        {rel: 'self', href: "#{ApplicationController.hostname}/owners/#{object.id}"},
        {rel: 'certificates', href: "#{ApplicationController.hostname}/owners/#{object.id}/certificates"},
        {rel: 'search', href: "#{ApplicationController.hostname}/owners{?n,email,acme_id,contains,starts_with}"}
    ]
  end
end
