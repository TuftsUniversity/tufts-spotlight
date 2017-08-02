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
end

