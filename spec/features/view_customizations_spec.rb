# @file
# Tests for the little customizations we do on views.

require 'rails_helper'

feature 'Views customizations' do

  # Checks that the sign-in link is removed.
  scenario 'Removed Sign in link' do
    visit(root_path)
    within('#header-navbar') do
      expect(page).to have_no_selector(:link, 'Sign in')
    end
  end

  # Checks the "External URL" field on Uploads is displaying correctly.
  describe 'Custom Configuration field tufts_source_location' do
    let(:field) { 'tufts_source_location_tesim' }
    let(:exhibit) { FactoryBot.create(:exhibit) }
    let(:image) do
      FactoryBot.create(
        :featured_image,
        image: File.open(File.join(Rails.root, 'spec', 'fixtures', 'stego.jpg'))
      )
    end
    let(:upload) do
      FactoryBot.create(
        :uploaded_resource,
        exhibit: exhibit,
        upload: image,
        data: { field => 'https://exhibits.tufts.edu' }
      )
    end

    scenario 'tufts_source_location displays as link' do
      upload.reindex
      sleep 1
      visit("#{spotlight.search_exhibit_catalog_path(exhibit)}?search_field=all_fields")
      within('.document') do
        expect(find('dd.blacklight-tufts_source_location_tesim').text).to eq('Click to view object')
      end
    end
  end

  # Checks that the header on the main page changes if you choose one of the exhibit tags.
  describe 'Site-wide tags change header on main page' do
    let(:tisch_tag) { "Tisch Library" }
    let(:tisch_title) { "Tisch Library Exhibits" }
    let(:tisch_exhibit) { FactoryBot.create(:exhibit, tag_list: tisch_tag) }

    let(:dca_tag) { "Tufts Archives" }
    let(:dca_title) { "Tufts Archives Exhibits" }
    let(:dca_exhibit) { FactoryBot.create(:exhibit, tag_list: dca_tag) }

    scenario "Dynamic header for tisch/dca" do
      tisch_exhibit
      dca_exhibit

      visit(root_path)
      expect(find(".site-title").text).to eq("Blacklight")

      within(".tags") do
        click_link(tisch_tag)
      end
      expect(find(".site-title").text).to eq(tisch_title)

      within(".tags") do
        click_link(dca_tag)
      end
      expect(find(".site-title").text).to eq(dca_title)
    end
  end
end

