# frozen_string_literal: true

require 'rails_helper'

describe Spotlight::Resources::Upload, type: :model do
  let(:exhibit) { FactoryBot.create(:exhibit) }
  let(:fields) { Spotlight::Resources::Upload.fields(exhibit) }

  it 'contains a tufts_source_location field' do
    expect(fields).to include(an_object_satisfying do |f|
      f.instance_variable_get(:@field_name) == :tufts_source_location_tesim
    end)
  end
end
