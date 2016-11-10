require 'rails_helper'

describe FedoraHelpers::ImageDatastream do
  let(:pid) { "tufts:MS054.003.DO.02108" }
  let(:ds_name) { "Basic.jpg" }
  let(:obj) {
    stream = ActiveFedora::Base.find(pid).datastreams[ds_name]
    FedoraHelpers::ImageDatastream.new(stream)
  }

  describe "initialization" do
    it "saves the image path to @location" do
      expect(obj.location).to eq("http://bucket01.lib.tufts.edu/data01/tufts/central/dca/MS054/basic_jpg/MS054.003.DO.02108.basic.jpg")
    end
  end

end
