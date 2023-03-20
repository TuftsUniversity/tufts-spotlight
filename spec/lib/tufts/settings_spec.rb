# frozen_string_literal: true

require 'rails_helper'

describe Tufts::Settings do
  describe 'load' do
    it 'returns either the prod or dev tdl url for tdl_url' do
      expect(described_class.load[:tdl_url]).to eq('https://dl.tufts.edu/concern/images/')
    end
  end
end
