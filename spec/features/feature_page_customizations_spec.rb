# @file
# Tests for in_menu addition to feature pages

require 'rails_helper'
include FeatureMacros
i_need_ldap

feature "Feature Page customizations" do
  let(:exhibit) { FactoryGirl.create(:exhibit) }
  let(:exhibit_admin) do
    FactoryGirl.create(:tufts_exhibit_admin, exhibit: exhibit)
  end

  # Visible page only exists to force Spotlight to create a menu.
  let(:visible_page) do
    FactoryGirl.create(
      :feature_page,
      title: "Visible",
      exhibit: exhibit
    )
  end
  let(:hidden_page) do
    FactoryGirl.create(
      :feature_page,
      title: "Hidden",
      exhibit: exhibit
    )
  end

  before(:each) do
    hidden_page
    sign_in(exhibit_admin)
  end

  scenario "'In menu' checkbox exists in form, and successfully sets value in db" do
    visit(spotlight.edit_exhibit_feature_page_path(exhibit, hidden_page))

    expect(Spotlight::FeaturePage.find(hidden_page.id).in_menu).to be true
    expect(page).to have_field("In menu", { checked: true })

    uncheck("In menu")
    click_button("Save")
    click_link("Edit")

    expect(Spotlight::FeaturePage.find(hidden_page.id).in_menu).to be false
    expect(page).to have_field("In menu", { unchecked: true })
  end

  scenario "In menu checkbox adds/removes page from menus", js: true do
    visible_page

    # Verify page starts in navigation.
    visit(spotlight.exhibit_feature_page_path(exhibit, visible_page))
    within("#sidebar") do
      expect(has_content?("Visible")).to be(true)
      expect(has_link?("Hidden", visible: :all)).to be(true)
    end
    within("#exhibit-navbar") do
      expect(has_link?("Visible", visible: :all)).to be(true)
      expect(has_link?("Hidden", visible: :all)).to be(true)
    end

    visit(spotlight.edit_exhibit_feature_page_path(exhibit, hidden_page))
    click_link("Options")

    # Hide "Hidden"
    uncheck("In menu")
    click_button("Save")
    click_link("Edit")
    click_link("Options")

    # Verify page is no longer in navigation.
    visit(spotlight.exhibit_feature_page_path(exhibit, visible_page))
    within("#sidebar") do
      expect(has_content?("Visible")).to be(true)
      expect(has_link?("Hidden", visible: :all)).to be(false)
    end
    within("#exhibit-navbar") do
      expect(has_link?("Visible", visible: :all)).to be(true)
      expect(has_link?("Hidden", visible: :all)).to be(false)
    end
  end
end

