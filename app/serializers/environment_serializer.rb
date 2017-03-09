class EnvironmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :destination_crt, :links

  def links
    [
        {rel: 'self', href: "#{ApplicationController.hostname}/environments/#{object.id}"},
        {rel: 'search', href: "#{ApplicationController.hostname}/environments{?n,contains,starts_with}"}
    ]
  end

end
