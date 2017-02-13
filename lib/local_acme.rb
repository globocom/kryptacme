require 'acme-client'
require 'singleton'
require 'openssl'
require 'net/http'

class LocalAcme
  include Singleton

  def initialize
    @acme_endpoint = APP_CONFIG['acme_endpoint']
    @gdns_endpoint = APP_CONFIG['gdns_endpoint']
    @gdns_token = APP_CONFIG['gdns_token']
    @dest_crt = APP_CONFIG['dest_crt']
  end

  def register_project(project)
    client = _new_client(project)
    _register_client(client, project, true) unless client.nil?
  end

  def revoke_cert(certificate)
    client = _new_client(certificate.project)
    cert = OpenSSL::X509::Certificate.new(certificate.last_crt)
    client.revoke_certificate(cert)
    certificate.revoked!
  end

  def request_cert(certificate)
      client = _new_client(certificate.project)
      authorization = client.authorize(domain: certificate.cn)
      challenge = authorization.dns01
      token = challenge.record_content
      add_dns_txt(certificate.cn, token)
      CertificatesChallengeJob.set(wait: 3.minutes).perform_later(certificate,authorization.uri) #TODO move to job or controller
  end

  def challenge(certificate, authorization)
    client = _new_client(certificate.project)
    challenge = client.fetch_authorization(authorization).dns01
    challenge.request_verification
    sleep(2)
    challenge.authorization.verify_status
    if challenge.authorization.verify_status == 'valid'
      csr_param = OpenSSL::X509::Request.new(certificate.csr)
      crt = client.new_certificate(csr_param)
      crt_pem = crt.to_pem

      path = @dest_crt + "#{certificate.cn}.pem"
      File.open(path, "w+") do |f|
        f.write("#{crt_pem}\n#{certificate.key}")
      end

      certificate.last_crt = crt_pem
      certificate.valid_rec!
      certificate.save
    else
      certificate.invalid_rec!
      certificate.status_detail = challenge.authorization.dns01.error
      certificate.save
      puts challenge.authorization.dns01.error
      #TODO What do case fail?
    end
  end

  private
  def _new_client(project)
    raise "Project does not exist or project does not contains the private key" if project.nil? or project.private_pem.nil?
    pem = project.private_pem.split('@').join(10.chr)
    private_key = OpenSSL::PKey::RSA.new(pem)
    client = Acme::Client.new(private_key: private_key,
                              endpoint: @acme_endpoint,
                              connection_options: {request: {open_timeout: 5, timeout: 5}})
    raise "Some error happined when create client with LetsEncrypt" if client.nil?
    return client
  end

  def _register_client(client, project, agree=false)
    contact = "mailto:#{project.email}".freeze
    registration = client.register(contact: contact)
    registration.agree_terms if agree and !registration.nil?
  end

  def add_dns_txt(domain, token) #TODO verify status http code to return error or success
    id_domain = add_domain_with_records(domain)
    add_record_token(domain, id_domain, token)
    call_export
  end

  def call_export
    uri = URI(@gdns_endpoint + "/bind9/schedule_export.json")
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req['X-Auth-Token'] = @gdns_token

    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    puts res.body
  end

  def add_record_token(domain, id_domain, token)
    uri = URI(@gdns_endpoint + "/domains/#{id_domain}/records.json")
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req['X-Auth-Token'] = @gdns_token

    req.body = {record: {name: "_acme-challenge.#{domain}.", type: "TXT", content: "#{token}"}}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
  end

  def search_gdns(domain)
    uri = URI(@gdns_endpoint + '/domains.json')
    params = { :query => domain }
    uri.query = URI.encode_www_form(params)
    req = Net::HTTP::Get.new(uri)
    req['X-Auth-Token'] = @gdns_token

    res = Net::HTTP.start(uri.hostname) do |http|
      http.request(req)
    end

    if !res.is_a?(Net::HTTPSuccess)
      puts 'Search domain failed'
      return nil #TODO Return error with gdns
    end
    domains_res = JSON.parse res.body
    return domains_res
  end

  def add_domain_with_records(domain)
    id_domain = nil
    res_domain = search_gdns(domain)
    if res_domain.empty?
      uri = URI(@gdns_endpoint + '/domains.json')
      req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      req['X-Auth-Token'] = @gdns_token
      req.body = {domain: {name: domain, type: "MASTER", ttl: 86400, notes: "A domain", primary_ns: "ns01.#{domain}", contact: "fapesp.corp.globo.com", refresh: 10800, retry: 3600, expire: 604800, minimum: 21600, authority_type: "M"}}.to_json
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      if res.is_a?(Net::HTTPSuccess)
        domain_created = JSON.parse res.body
        if !domain_created.empty?
          id_domain = domain_created['domain']['id']
          uri = URI(@gdns_endpoint + "/domains/#{id_domain}/records.json")
          req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
          req['X-Auth-Token'] = @gdns_token

          req.body = {record: {name: "@", type: "NS", content: "ns01.globo.com"}}.to_json
          res = Net::HTTP.start(uri.hostname, uri.port) do |http|
            http.request(req)
          end
          #TODO verify if success, because if not, we have delete the domain created for avoid problem with export
        end
      else
        #TODO return error
      end
    else
      id_domain = res_domain[0]['domain']['id']
    end
    return id_domain

  end
end