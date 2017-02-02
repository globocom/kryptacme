class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :detail, :acme_id, :links

  def links
    [
        {rel: 'self', href: "#{ApplicationController.hostname}/projects/#{object.id}"},
        {rel: 'certificates', href: "#{ApplicationController.hostname}/projects/#{object.id}/certificates"},
        {rel: 'search', href: "#{ApplicationController.hostname}/projects{?n,email,acme_id,contains,starts_with}"}
    ]
  end
end
