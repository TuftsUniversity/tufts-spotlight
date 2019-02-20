require 'rails_helper'

RSpec.describe SpotlightHelper do
  let(:fake_field) do { value: ['test.com'] } end
  let(:link) { "<a target=\"_blank\" href=\"test.com\">Click to view object</a>" }

  describe 'make_source_location_link' do
    it 'Creates a link when passed a Hash with a url in :value' do
      expect(make_source_location_link(fake_field)).to eq(link)
    end
  end
end
