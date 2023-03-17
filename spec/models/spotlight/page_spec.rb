# frozen_string_literal: true

require 'rails_helper'

describe Spotlight::Page do
  let(:page) { FactoryBot.build(:feature_page) }

  it 'has a valid factory' do
    expect(page).to be_valid
  end

  it 'defaults in_menu to true' do
    expect(page.in_menu).to eq(true)
  end
end
