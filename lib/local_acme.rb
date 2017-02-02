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
  end

  def register_project(project)
    client = _new_client(project)
    _register_client(client, project, true) unless client.nil?
  end

  def request_cert(certificate)
    begin
      client = _new_client(certificate.project)
      raise StandardError if client.nil?
      authorization = client.authorize(domain: certificate.cn)
      challenge = authorization.dns01
      token = challenge.token
      puts "TOKEN: #{token}"
      add_dns_txt(certificate.cn, token)
      challenge.request_verification

      csr = Acme::Client::CertificateRequest.new(names: %W[ #{certificate.cn} ])
      crt = client.new_certificate(csr)
      certificate.last_crt = crt.to_pem
    rescue Acme::Client::Error::Unauthorized => detail
      puts "#{detail.class}: #{detail.message}"
    rescue => detail
      puts "#{detail.class}: #{detail.message}"
      print detail.backtrace.join("\n")
    end
  end

  private
  def _new_client(project)
    begin
      return nil if project.nil? or project.private_pem.nil?
      pem = project.private_pem.split('@').join(10.chr)
      private_key = OpenSSL::PKey::RSA.new(pem)
      client = Acme::Client.new(private_key: private_key,
                                endpoint: @acme_endpoint,
                                connection_options: {request: {open_timeout: 5, timeout: 5}})
      return client
    rescue => detail
      puts "#{detail.class}: #{detail.message}"
      return nil
    end
  end

  def _register_client(client, project, agree=false)
    registration = nil
    begin
      contact = "mailto:#{project.email}".freeze
      registration = client.register(contact: contact)
    rescue => detail
      puts "#{detail.class}: #{detail.message}"
      print detail.backtrace.join("\n")
    end
    registration.agree_terms if agree and !registration.nil?
  end

  def add_dns_txt(domain, token)
    id_domain = add_domain_with_records(domain)
    add_record_token(id_domain, token)
    call_export
  rescue => e
    puts "failed #{e}"
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

  def add_record_token(id_domain, token)
    uri = URI(@gdns_endpoint + "/domains/#{id_domain}/records.json")
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req['X-Auth-Token'] = @gdns_token

    req.body = {record: {name: "acme-challenge.#{domain}", type: "TXT", content: "#{token}"}}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    #TODO verify if success for export
    puts res.body
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
    puts domains_res

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
          puts res.body
        end
      else
        #TODO return error to client
        puts res.body
      end
    else
      id_domain = res_domain[0]['domain']['id']
    end
    return id_domain

  end
end