require 'rails_helper'

describe FedoraHelpers::ImageDatastream do
  let(:pid) { "tufts:MS054.003.DO.02108" }
  let(:ds_name) { "Basic.jpg" }
  let(:obj) {
    stream = ActiveFedora::Base.find(pid).datastreams[ds_name]
    FedoraHelpers::ImageDatastream.new(stream)
  }

  describe "initialization" do
    context "with a valid stream" do
      it "saves the image path to @location" do
        expect(obj.location).to eq("http://bucket01.lib.tufts.edu/data01/tufts/central/dca/MS054/basic_jpg/MS054.003.DO.02108.basic.jpg")
      end
    end

    context "with an invalid stream" do
      it "saves an empty string to @location" do
        obj = FedoraHelpers::ImageDatastream.new({})
        expect(obj.location).to eq("")
      end
    end
  end

end
