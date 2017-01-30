require 'rails_helper'

class ConfigParserTestClass
  include FedoraHelpers::ConfigParser

  def initialize
    @settings = load_yaml("spec/fixtures/fedora_fields.yml")
  end
end


describe FedoraHelpers::ConfigParser do
  let(:obj) { ConfigParserTestClass.new }

  # Class method
  describe "load_yaml" do
    it "returns a hash from a yaml file" do
      yaml = FedoraHelpers::ConfigParser.load_yaml("spec/fixtures/fedora_fields.yml")
      expect(yaml).to be_a(Hash)
      expect(yaml).to_not be_empty
    end

    it "is available as instance method" do
      expect(obj.instance_variable_get(:@settings)).to_not be_empty
    end
  end

end

