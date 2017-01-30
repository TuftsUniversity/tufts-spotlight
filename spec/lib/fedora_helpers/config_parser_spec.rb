require 'rails_helper'

describe FedoraHelpers::ConfigParser do

  # Class method
  describe "load_yaml" do
    it "returns a hash from a yaml file" do
      yaml = FedoraHelpers::ConfigParser.load_yaml("spec/fixtures/fedora_fields.yml")
      expect(yaml).to be_a(Hash)
      expect(yaml).to_not be_empty
    end
  end
end

