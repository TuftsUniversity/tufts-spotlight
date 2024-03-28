# frozen_string_literal: true

# @file
# Tests for the Sir Trevor customizations in tufts_spotlight_blocks.

## TODO: I think spot light has moved away for sirtrevor
# require 'rails_helper'
# require 'webdrivers/chromedriver'
# i_need_ldap

# feature 'Tufts Spotlight Blocks customizations' do
#   include FeatureMacros
#   let(:exhibit) { FactoryBot.create(:exhibit) }

#   let(:exhibit_admin) do
#     FactoryBot.create(:tufts_exhibit_admin, exhibit: exhibit)
#   end

#   let(:feature_page) do
#     FactoryBot.create(
#       :feature_page,
#       exhibit: exhibit,
#       thumbnail: FactoryBot.create(:featured_image)
#     )
#   end

#   before do
#     sign_in(exhibit_admin)
#     visit(spotlight.edit_exhibit_feature_page_path(exhibit, feature_page))
#   end

#   scenario 'adds captions to the solr documents embed block', js: true do
#     add_block('solr_documents_embed')
#     expect(page).to have_css('.primary-caption')
#   end

#   scenario 'shows and hides the autocomplete for feature page blocks', js: true do
#     add_block('featured_pages')

#     ac = find('#st-editor-1 [data-twitter-typeahead]')
#     warning = find(
#       'p',
#       text: 'This feature row is at the maximum number of items.',
#       visible: false
#     )

#     # Ac on - warning off, by default
#     expect(ac.visible?).to be(true)
#     expect(warning.visible?).to be(false)

#     # Ac off - warning on, when adding 3 items (sidebar on)
#     add_autocomplete_item
#     add_autocomplete_item
#     add_autocomplete_item
#     sleep(0.5)
#     expect(ac.visible?).to be(false)
#     expect(warning.visible?).to be(true)

#     # Ac on - warning off, when removing sidebar (3 items)
#     toggle_sidebar('remove')
#     expect(ac.visible?).to be(true)
#     expect(warning.visible?).to be(false)

#     # Ac off - warning on, when adding 2 items, 5 total (no sidebar)
#     add_autocomplete_item
#     add_autocomplete_item
#     sleep(0.5)
#     expect(ac.visible?).to be(false)
#     expect(warning.visible?).to be(true)

#     # Ac on - warning off, when removing 1 item, 4 total (no sidebar)
#     remove_autocomplete_item
#     sleep(0.5)
#     expect(ac.visible?).to be(true)
#     expect(warning.visible?).to be(false)

#     # Ac off - warning on, when re-adding sidebar (4 items)
#     toggle_sidebar
#     expect(ac.visible?).to be(false)
#     expect(warning.visible?).to be(true)

#     # Ac off - warning on, after page save/reload
#     click_button('Save changes')
#     sleep(1)
#     visit(spotlight.edit_exhibit_feature_page_path(exhibit, feature_page))
#     expect(page).to have_no_css('#st-editor-1 .twitter-typeahead')
#     expect(page).to have_content('This feature row is at the maximum number of items.')
#   end
# end
