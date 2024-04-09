# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers/chromedriver'

feature 'TDL ingest' do
  include FeatureMacros
  #  before { skip('Tests ready, but need TDL migration to prod finished. TravisCI can't connect to dev.') }

  let(:ids) do
    %w[
      4b29bg82c
      3a29bg82c
      8336hb39g
      dv140335h
    ]
  end

  let(:exhibit) do
    FactoryBot.create(:exhibit)
  end

  let(:exhibit_admin) do
    FactoryBot.create(:tufts_exhibit_admin, exhibit: exhibit)
  end

  before do
    sign_in(exhibit_admin)
    visit(spotlight.new_exhibit_resource_path(exhibit))
  end

  after(:all) do
    clean_solr
  end

  scenario 'Valid id submission' do
    expect do
      within('#new_resources_tdl') do
        all('input').first.set(ids[0])
        click_button('Import Objects')
      end
    end.to change(Tufts::TdlResource, :count).by(1)

    expect(current_path).to eq(spotlight.admin_exhibit_catalog_path(exhibit))
    expect(page).to have_content('Successfully created 1 record.')
  end

  scenario 'Invalid id submission' do
    expect do
      within('#new_resources_tdl') do
        all('input').first.set('boo')
        click_button('Import Objects')
      end
    end.to change(Tufts::TdlResource, :count).by(0)

    expect(current_path).to eq(spotlight.admin_exhibit_catalog_path(exhibit))
    expect(page).to have_content('There was an error with the following ids -- boo')
  end

  scenario "Three More Fields' button adds fields, up to 15", js: true do
    click_on('Tufts Digital Library Object')

    within('#new_resources_tdl') do
      expect(all("input[type='text']").length).to eq(1)
      click_button('Three More Fields')
      expect(all("input[type='text']").length).to eq(4)
      4.times do
        click_button('Three More Fields')
      end
      expect(all("input[type='text']").length).to eq(16)
    end
  end

  scenario 'Combining valid ids, invalid ids, and blank fields.', js: true do
    click_on('Tufts Digital Library Object')

    expect do
      within('#new_resources_tdl') do
        3.times { click_button('Three More Fields') }
        inputs = all("input[type='text']")
        inputs[0].set(ids[0])
        # TODO: note 3x816x422 is no longer a valid id
        inputs[1].set(ids[1]) # this is the prblem somehow
        inputs[3].set('garbage')
        inputs[5].set(ids[2])
        inputs[6].set('moregarbage')
        inputs[7].set(ids[3])
        click_button('Import Objects')
      end
    end.to change(Tufts::TdlResource, :count).by(3)

    expect(current_path).to eq(spotlight.admin_exhibit_catalog_path(exhibit))
    expect(page).to have_content('Successfully created 3 records.')
    expect(page).to have_content('There was an error with the following ids -- 3a29bg82c -- garbage -- moregarbage')
  end
end
