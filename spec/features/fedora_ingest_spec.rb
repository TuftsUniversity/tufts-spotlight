require 'rails_helper'
include FeatureMacros
i_need_ldap


feature "Fedora 3 ingest" do
  let(:pids) do
    pids = [
      "tufts:MS054.003.DO.02108",
      "tufts:TBS.VW0001.000113",
      "tufts:TBS.VW0001.002493",
      "tufts:TBS.VW0001.000386"
    ]
  end

  let(:exhibit) do
    FactoryBot.create(:exhibit)
  end

  let(:exhibit_admin) do
    FactoryBot.create(:tufts_exhibit_admin, exhibit: exhibit)
  end

  before(:each) do
    sign_in(exhibit_admin)
    visit(spotlight.new_exhibit_resource_path(exhibit))
  end

  after(:all) do
    clean_solr
  end

  scenario "Valid pid submission" do
    expect {
      within("#new_resources_fedora") do
        all("input").first.set(pids[0])
        click_button("Import Objects")
      end
    }.to change(FedoraResource, :count).by(1)

    expect(current_path).to eq(spotlight.admin_exhibit_catalog_path(exhibit))
    expect(page).to have_content("Successfully created 1 record.")
  end

  scenario "Invalid pid submission" do
    expect {
      within("#new_resources_fedora") do
        all("input").first.set("boo")
        click_button("Import Objects")
      end
    }.to change(FedoraResource, :count).by(0)

    expect(current_path).to eq(spotlight.admin_exhibit_catalog_path(exhibit))
    expect(page).to have_content("There was an error with the following ids -- boo")
  end # End Invalid PID submission

  scenario "'Three More Fields' button adds fields, up to 15", js: true do
    within("#new_resources_fedora") do
      expect(all('input[type="text"]').length).to eq(1)
      click_button("Three More Fields")
      expect(all('input[type="text"]').length).to eq(4)
      4.times do
        click_button("Three More Fields")
      end
      expect(all('input[type="text"]').length).to eq(16)
    end
  end

  scenario "Combining valid pids, invalid pids, and blank fields.", js: true do
    expect {
      within("#new_resources_fedora") do 
        3.times { click_button("Three More Fields") }
        inputs = all('input[type="text"]')
        inputs[0].set(pids[0])
        inputs[1].set(pids[1])
        inputs[3].set("garbage")
        inputs[5].set(pids[2])
        inputs[6].set("moregarbage")
        inputs[7].set(pids[3])
        click_button("Import Objects")
      end
    }.to change(FedoraResource, :count).by(4)

    expect(current_path).to eq(spotlight.admin_exhibit_catalog_path(exhibit))
    expect(page).to have_content("Successfully created 4 records.")
    expect(page).to have_content("There was an error with the following ids -- garbage -- moregarbage")
  end # End Ingesting a record

end
