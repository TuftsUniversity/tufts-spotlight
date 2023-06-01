# frozen_string_literal: true
class OmniauthController < Devise::SessionsController
  def new
    if Rails.env.production? || Rails.env.tdldev?
      redirect_to user_shibboleth_omniauth_authorize_path
    else
      super
    end
  end
end
