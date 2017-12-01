class ApplicationController < ActionController::Base

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

  helper Openseadragon::OpenseadragonHelper

  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Spotlight::Controller

  layout 'blacklight'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  ## Remove?
  # Get rid of that annoying paper trail error
  #def user_for_paper_trail
  #  nil
  #end
  ##
end
