require 'rails_helper'

feature "Fedora 3 ingest" do
  pid = "tufts:MS054.003.DO.02108"

  scenario "Ingesting a record" do
    exhibit = FactoryGirl.create(:exhibit)
    admin = FactoryGirl.create(:tufts_exhibit_admin, exhibit: exhibit)
    sign_in(admin)
  end

end

