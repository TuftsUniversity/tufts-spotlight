require 'rails_helper'


## Mock class for testing.
class ConfigParserTestClass
  include FedoraHelpers::ConfigParser

  def initialize
    set_fedora_settings("config/fedora_fields.yml")
  end
end


describe FedoraHelpers::ConfigParser do
  let(:obj) { ConfigParserTestClass.new }
  let(:settings) { obj.instance_variable_get(:@fedora_settings) }

  # Class and instance method
  describe "load_yaml" do
    it "returns a hash from a yaml file" do
      yaml = FedoraHelpers::ConfigParser.load_yaml("config/fedora_fields.yml")
      expect(yaml).to be_a(Hash)
      expect(yaml).to_not be_empty
    end

    it "is used to set @fedora_settings" do
      expect(
        obj.instance_variable_get(:@fedora_settings)
      ).to_not be_empty
    end
  end

  describe "get_show_fields" do
    let(:results) { obj.get_show_fields }

    it "retrieves only show fields" do
      expect(results).not_to be_empty
      # Every field that is not an index field, is a show field
      expect(results).to all(not_include( {results: true} ))
    end

    it "retrieves from all datastreams" do
      expect(results).to include( {field: "source"} )
      expect(results).to include(
        {field: "/RDF/Description/isMemberOfCollection/@resource", name: "member_of"} 
      )
    end
  end #End get_show_fields

  describe "get_index_fields" do
    let(:results) { obj.get_index_fields }

    it "retrieves only the index fields" do
      expect(results).not_to be_empty
      expect(results).to all(include( {results: true} ))
    end
  end

  describe "get_facet_fields" do
    let(:results) { obj.get_facet_fields }

    it "retrieves only the facet fields" do
      expect(results).not_to be_empty
      expect(results).to all(include( {facet: true} ))
    end
  end


end

