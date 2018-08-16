require 'rails_helper'

describe Tufts::Settings do
  let(:settings) { Tufts::Settings.load }

  let(:valid_urls) do
    [
      "https://tdl-dev-01.uit.tufts.edu/concern/images/",
      "https://tdl-prod-01.uit.tufts.edu/concern/images/"
    ]
  end

  describe "load" do
    it "returns either the prod or dev tdl url for tdl_url" do
      expect(valid_urls).to include(settings[:tdl_url])
    end
  end
end