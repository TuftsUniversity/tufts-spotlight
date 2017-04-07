# @file
# Tests for the Sir Trevor customizations in tufts_spotlight_blocks.

require 'rails_helper'
i_need_ldap


feature "Tufts Spotlight Blocks customizations" do
  let(:exhibit) { FactoryGirl.create(:exhibit) }

  let(:exhibit_admin) do
    FactoryGirl.create(:tufts_exhibit_admin, exhibit: exhibit)
  end

  before(:each) do
    sign_in(exhibit_admin)
    visit(spotlight.edit_exhibit_home_page_path(exhibit))
  end

  scenario "adds captions to the solr documents embed block", js: true do
    within("#st-editor-1") do
      click_button(class: "st-block-replacer")
      save_and_open_page
    end
  end
end

