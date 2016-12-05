require 'rails_helper'

feature "Fedora 3 ingest" do
  pid = "tufts:MS054.003.DO.02108"

  scenario "Ingesting a record" do
    exhibit = FactoryGirl.create(:exhibit)
    admin = FactoryGirl.create(:tufts_exhibit_admin, exhibit: exhibit)
    sign_in(admin)

    visit(spotlight.new_exhibit_resource_path(exhibit))

    expect {
      within("#new_resource") do
        fill_in("Fedora ID:", with: pid)
        click_button("Do It!")
      end
    }.to change(FedoraResource, :count).by(1)
  end # End Ingesting a record

end

