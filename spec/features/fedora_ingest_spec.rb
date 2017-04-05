require 'rails_helper'
i_need_ldap


feature "Fedora 3 ingest" do
  let(:pid) { pid = "tufts:MS054.003.DO.02108" }

  let(:exhibit) do
    FactoryGirl.create(:exhibit)
  end

  let(:exhibit_admin) do
    FactoryGirl.create(:tufts_exhibit_admin, exhibit: exhibit)
  end

  before(:each) do
    sign_in(exhibit_admin)
    visit(spotlight.new_exhibit_resource_path(exhibit))
  end

  after(:all) do
    clean_solr
  end

  scenario "Ingesting valid Fedora record" do
    expect {
      within("#new_resource") do
        fill_in("Fedora ID:", with: pid)
        click_button("Do It!")
      end
    }.to change(FedoraResource, :count).by(1)

    expect(current_path).to eq(spotlight.admin_exhibit_catalog_path(exhibit))
  end # End Ingesting a record

  scenario "Invalid PID submission" do
    expect {
      within("#new_resource") do
        fill_in("Fedora ID:", with: "boooo")
        click_button("Do It!")
      end
    }.to change(FedoraResource, :count).by(0)

    expect(current_path).to eq(spotlight.new_exhibit_resource_path(exhibit))
    expect(page).to have_content("is not a valid pid")
  end # End Invalid PID submission

end
