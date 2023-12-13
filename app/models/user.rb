# frozen_string_literal: true

class User < ApplicationRecord
  include Spotlight::User
  # TODO: circle back https://github.com/projectblacklight/blacklight/issues/2055
  # attr_accessible :email, :password, :password_confirmation if Blacklight::Utils.needs_attr_accessible?
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User

  if Rails.env.development? || Rails.env.test?
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    # Removed :recoverable and :registerable to eliminate unwanted links on login page
    devise :invitable, :ldap_authenticatable,
         :trackable, :validatable
    # copied devise,think through these modules and there differeneces.
    # devise :ldap_authenticatable, :registerable,
    #         :recoverable, :rememberable, :trackable, :validatable
  else
    # Issue here: some how this is not working
    # devise_modules = [:omniauthable, :rememberable, :trackable, omniauth_providers: [:shibboleth]]
    devise_modules = [:omniauthable, :rememberable, :trackable, omniauth_providers: [:shibboleth], authentication_keys: [:username]]
    devise(*devise_modules)
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # Removed :recoverable and :registerable to eliminate unwanted links on login page
  devise :invitable, :ldap_authenticatable,
         :trackable, :validatable

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  ## Remove?
  # Added this so validation will succeed when the user first logs in via ldap and the account is created.
  def ldap_before_save
    self.email = Devise::LDAP::Adapter.get_ldap_param(username, 'mail').first
  end

  # allow omniauth (including shibboleth) logins
  #   this will create a local user based on an omniauth/shib login
  #   if they haven't logged in before
  def self.from_omniauth(auth)
    logger.warn "Finding omni user auth:: #{auth}"
    user = find_by(username: auth[:uid])
    if user.nil?
      user = User.create(
        email: auth[:mail],
        username: auth[:uid]
      )
    else
      user.username = auth[:uid]
      user.email = auth[:mail]
      user.save
    end
    user
  end
end
