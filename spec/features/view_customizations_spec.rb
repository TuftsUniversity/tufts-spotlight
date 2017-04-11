# @file
# Tests for the little customizations we do on views.

require 'rails_helper'

feature "Views customizations" do

  scenario "Removed Sign in link" do
    visit(root_path)
    within("#header-navbar") do
      expect(page).to have_no_selector(:link, "Sign in")
    end
  end


  let(:tisch_tag) { "Tisch Library" }
  let(:tisch_title) { "Tisch Library Exhibits" }
  let(:tisch_exhibit) { FactoryGirl.create(:exhibit, tag_list: tisch_tag) }

  let(:dca_tag) { "Tufts Archives" }
  let(:dca_title) { "Tufts Archives Exhibits" }
  let(:dca_exhibit) { FactoryGirl.create(:exhibit, tag_list: dca_tag) }

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

