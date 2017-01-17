require 'socket'

class ApplicationController < ActionController::API
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  before_action :_set_hostname

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

begin
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) << :username
  end
end

  @@hostname = nil

  def self.hostname
    @@hostname
  end

  private
  def _set_hostname
    @@hostname = "#{request.protocol}#{request.host_with_port}" || "#{request.protocol}#{Socket.gethostname}" if @@hostname.nil?
  end
end
