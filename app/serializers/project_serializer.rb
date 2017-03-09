class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :links

  def links
    [
        {rel: 'self', href: "#{ApplicationController.hostname}/projects/#{object.id}"},
        {rel: 'certificates', href: "#{ApplicationController.hostname}/projects/#{object.id}/certificates"},
        {rel: 'search', href: "#{ApplicationController.hostname}/projects{?n,contains,starts_with}"}
    ]
  end
end
