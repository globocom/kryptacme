require 'socket'

class ApplicationController < ActionController::API
  before_action :_set_hostname

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authorization

  begin
    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
    end
  end

  @@hostname = nil

  def self.hostname
    @@hostname
  end

  def admin_only
    unless current_user.admin?
      render :json => {message: 'Only Admin - Access Denied'}, status: 403
    end
  end

  def authorization
    current_action = params[:action]
    write_admin = current_user.present? && (current_user.write? || current_user.admin?)
    read = current_user.present? && current_user.read? && (['index','show'].include? current_action)
    unless write_admin || read
      render :json => {message: 'Authorization - Access Denied'}, status: 403
    end
  end

  private
  def _set_hostname
    @@hostname = "#{request.protocol}#{request.host_with_port}" || "#{request.protocol}#{Socket.gethostname}" if @@hostname.nil?
  end
end
