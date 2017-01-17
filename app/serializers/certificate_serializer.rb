class CertificateSerializer < ActiveModel::Serializer
  attributes :id, :cn, :last_crt, :csr, :key, :detail, :acme_id, :links
  #has_one :owner

  def links
    [
        {rel: 'self', href: "#{ApplicationController.hostname}/owners/#{object.owner.id}/certificates/#{object.id}"},
        {rel: 'owner', href: "#{ApplicationController.hostname}/owners/#{object.owner.id}"},
        {rel: 'search', href: "#{ApplicationController.hostname}/owners/#{object.owner.id}/certificates{?cn,acme_id,contains,starts_with}"}
    ]
  end
end
