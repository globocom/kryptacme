class CertificateSerializer < ActiveModel::Serializer
  attributes :id, :cn, :created_at, :updated_at, :expired_at, :last_crt, :csr, :status, :status_detail, :links

  def links
    [
        {rel: 'self', href: "#{ApplicationController.hostname}/projects/#{object.project.id}/certificates/#{object.id}"},
        {rel: 'project', href: "#{ApplicationController.hostname}/projects/#{object.project.id}"},
        {rel: 'search', href: "#{ApplicationController.hostname}/projects/#{object.project.id}/certificates{?cn,contains,starts_with}"}
    ]
  end
end
