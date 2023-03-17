# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tufts::TdlResource do
  #  before { skip('Tests ready, but need TDL migration to prod finished. TravisCI can't connect to dev.') }

  it 'has a valid factory' do
    expect(FactoryBot.build(:tdl_resource)).to be_valid
  end

  it 'is invalid with a bad url - and catches the exception' do
    expect(FactoryBot.build(:tdl_resource, url: 'booo')).not_to be_valid
  end
end
