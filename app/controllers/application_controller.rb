# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper

  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Spotlight::Controller

  layout 'blacklight'

  # Removes annoying deprecation notice. Can be removed when upgrading to Blacklight 7.0
  skip_after_action :discard_flash_if_xhr

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def guest_username_authentication_key(key)
    "spotlight_guest_#{guest_user_unique_suffix}"
  end

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render text: exception, status: :internal_server_error
  end
end
