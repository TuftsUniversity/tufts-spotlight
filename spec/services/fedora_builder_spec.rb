require 'rails_helper'
require 'lib/fedora_helpers_spec'

require 'mini_magick'

describe FedoraBuilder do
  it_behaves_like FedoraHelpers

  let(:obj) { FedoraBuilder.new(FedoraResourceStub.new) }

  describe "initialize" do
    it "loads the yaml into @settings" do
      expect(obj.instance_variable_get(:@settings)).not_to be_empty
    end
  end

  describe "to_solr" do
    let(:doc) { obj.to_solr }
    let(:expected_doc) do
      {
        full_title_tesim: "114 Professors Row",
        spotlight_resource_type_ssim: "spotlight/resources/fedora",
        f3_pid_ssi: "tufts:MS054.003.DO.02108",

        Spotlight::Engine.config.full_image_field => "http://bucket01.lib.tufts.edu/data01/tufts/central/dca/MS054/advanced_jpg/MS054.003.DO.02108.advanced.jpg",
        Spotlight::Engine.config.thumbnail_field => "http://bucket01.lib.tufts.edu/data01/tufts/central/dca/MS054/thumb_png/MS054.003.DO.02108.thumb.png"
      }
    end

    it "strips namespace and dots from id" do
      expect(obj.to_solr[:id]).to eq("MS054003DO02108")
    end

    it "returns a solr doc with the following values" do
      expect(obj.to_solr).to include(expected_doc)
    end
  end
end # End describe FedoraBuilder


##
# The stub that represents a resource object coming
# from spotlight.
class FedoraResourceStub < FedoraResource
  def url
    "tufts:MS054.003.DO.02108"
  end

  # Usually this is pulled from the exhibit, but the stub has no exhibit.
  def document_model
    SolrDocument
  end
end

