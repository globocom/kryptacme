class CertificateSerializer < ActiveModel::Serializer
  attributes :id, :cn, :last_crt, :csr, :key, :detail, :acme_id, :links
  #has_one :project

  def links
    [
        {rel: 'self', href: "#{ApplicationController.hostname}/projects/#{object.project.id}/certificates/#{object.id}"},
        {rel: 'project', href: "#{ApplicationController.hostname}/projects/#{object.project.id}"},
        {rel: 'search', href: "#{ApplicationController.hostname}/projects/#{object.project.id}/certificates{?cn,acme_id,contains,starts_with}"}
    ]
  end
end
