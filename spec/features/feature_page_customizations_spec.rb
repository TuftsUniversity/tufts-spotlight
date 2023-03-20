# frozen_string_literal: true

# @file
# Tests for in_menu addition to feature pages

require 'rails_helper'
i_need_ldap

feature 'Feature Page customizations' do
  include FeatureMacros
  let(:exhibit) { FactoryBot.create(:exhibit) }
  let(:exhibit_admin) do
    FactoryBot.create(:tufts_exhibit_admin, exhibit: exhibit)
  end

  let(:visible_page) do
    FactoryBot.create(
      :feature_page,
      title: 'Visible',
      exhibit: exhibit
    )
  end
  let(:hidden_page) do
    FactoryBot.create(
      :feature_page,
      title: 'Hidden',
      exhibit: exhibit,
      in_menu: false
    )
  end
  # Blank page just exists to force a dropdown menu.
  let(:blank_page) do
    FactoryBot.create(
      :feature_page,
      title: 'Filler',
      exhibit: exhibit
    )
  end

  before do
    visible_page
    sign_in(exhibit_admin)
  end

  scenario "In menu' checkbox exists in form, and sets value in db" do
    visit(spotlight.edit_exhibit_feature_page_path(exhibit, visible_page))

    expect(Spotlight::FeaturePage.find(visible_page.id).in_menu).to be(true)
    expect(page).to have_field('In menu', { checked: true })

    uncheck('In menu')
    click_button('Save')
    click_link('Edit')

    expect(Spotlight::FeaturePage.find(visible_page.id).in_menu).to be(false)
    expect(page).to have_field('In menu', { unchecked: true })
  end

  scenario 'In menu property displays/hides page in menus' do
    blank_page
    hidden_page

    visit(spotlight.exhibit_feature_page_path(exhibit, blank_page))
    within('#sidebar') do
      expect(has_link?('Visible')).to be(true)
      expect(has_link?('Hidden')).to be(false)
    end
    within('#exhibit-navbar') do
      expect(has_link?('Visible', visible: :all)).to be(true)
      expect(has_link?('Hidden', visible: :all)).to be(false)
    end
  end
end
