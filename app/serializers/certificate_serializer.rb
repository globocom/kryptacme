class CertificateSerializer < ActiveModel::Serializer
  attributes :id, :cn, :last_crt, :csr, :key, :status, :status_detail, :links

  def links
    [
        {rel: 'self', href: "#{ApplicationController.hostname}/projects/#{object.project.id}/certificates/#{object.id}"},
        {rel: 'project', href: "#{ApplicationController.hostname}/projects/#{object.project.id}"},
        {rel: 'search', href: "#{ApplicationController.hostname}/projects/#{object.project.id}/certificates{?cn,contains,starts_with}"}
    ]
  end
end
