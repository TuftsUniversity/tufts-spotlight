require 'rails_helper'

describe Tufts::Settings do
  describe "load" do
    it "returns either the prod or dev tdl url for tdl_url" do
      expect(Tufts::Settings.load[:tdl_url]).to eq('https://dl.tufts.edu/concern/images/')
    end
  end
end
