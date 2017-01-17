require 'socket'

class ApplicationController < ActionController::API
  before_action :_set_hostname

  @@hostname = nil

  def self.hostname
    @@hostname
  end

  private
  def _set_hostname
    @@hostname = "#{request.protocol}#{request.host_with_port}" || "#{request.protocol}#{Socket.gethostname}" if @@hostname.nil?
  end
end
