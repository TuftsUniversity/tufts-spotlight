# frozen_string_literal: true
class OmniauthcallbacksController < Devise::OmniauthCallbacksController
  # handle omniauth logins from shibboleth
  def shibboleth
    # auth_headers = %w(HTTP_AFFILIATION HTTP_AUTH_TYPE HTTP_COOKIE HTTP_HOST
    #   HTTP_PERSISTENT_ID HTTP_EPPN HTTP_REMOTE_USER HTTP_SHIB_APPLICATION_ID
    #   HTTP_SHIB_AUTHENTICATION_INSTANT HTTP_SHIB_AUTHENTICATION_METHOD
    #   HTTP_SHIB_AUTHNCONTEXT_CLASS HTTP_SHIB_HANDLER HTTP_SHIB_IDENTITY_PROVIDER
    #   HTTP_SHIB_SESSION_ID HTTP_SHIB_SESSION_INDEX HTTP_UNSCOPED_AFFILIATION)
    auth_headers = {
      uid: 'uid',
      shib_session_id: 'Shib-Session-ID',
      shib_application_id: 'Shib-Application-ID',
      provider: 'Shib-Identity-Provider',
      mail: 'mail'
    }
    auth = {}
    auth_headers.each do |k, v|
      auth[k] = request.env[v]
    end
    auth.compact_blank!
    @user = User.from_omniauth(auth)
    # capture data about the user from shib
    set_flash_message :notice, :success, kind: "Shibboleth"
    sign_in_and_redirect @user
  end

  ## when shib login fails
  # temp
  # rubocop:disable Rails/I18nLocaleTexts
  def failure
    ## redirect them to the devise local login page
    # redirect_to new_local_user_session_path, :notice => "Shibboleth isn't available - local login only"
    redirect_to root_path, notice: "Shibboleth isn't available - local login only"
  end
end
