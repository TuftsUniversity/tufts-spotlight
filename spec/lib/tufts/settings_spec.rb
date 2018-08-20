require 'rails_helper'

describe Tufts::Settings do
  let(:valid_urls) do
    [
      "https://tdl-dev-01.uit.tufts.edu/concern/images/",
      "https://tdl-prod-01.uit.tufts.edu/concern/images/"
    ]
  end

  describe "load" do
    it "returns either the prod or dev tdl url for tdl_url" do
      expect(valid_urls).to include(Tufts::Settings.load[:tdl_url])
    end
  end
end
