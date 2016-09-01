class User < ActiveRecord::Base
  include Spotlight::User
  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # Removed :recoverable and :registerable to eliminate unwanted links on login page
  devise :invitable, :ldap_authenticatable,
         :rememberable, :trackable, :validatable

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  # Added this so validation will succeed when the user first logs in via ldap and the account is created.
  def ldap_before_save
    self.email = Devise::LDAP::Adapter.get_ldap_param(self.username, "mail").first
  end

end
