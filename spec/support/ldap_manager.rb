module LdapManager
  def initialize
    @ldap_running = false;
  end

  def i_need_ldap
    unless(@ldap_running)
      @ldap_server = Ladle::Server.new(
        quiet: false,
        ldif: Rails.root.join("spec/fixtures/tufts_ldap.ldif")
      ).start

      @ldap_running = true;
    end
  end

  def stop_ldap
    if(@ldap_running)
      @ldap_server.stop
    end
  end
end
