require 'rails_helper'

describe FedoraHelpers::ImageDatastream do
  let(:pid) { "tufts:MS054.003.DO.02108" }
  let(:url) { "https://dl.tufts.edu/file_assets/" }
  let(:resource) { ActiveFedora::Base.find(pid) }

  describe "initialization" do
    context "with a basic stream" do
      it "translates and saves the image path to @location" do
        obj = FedoraHelpers::ImageDatastream.new(resource.datastreams['Basic.jpg'])
        expect(obj.location).to eq(url + "medium/" + pid)
      end
    end

    context "with an advanced stream" do
      it "translates and saves the image path to @location" do
        obj = FedoraHelpers::ImageDatastream.new(resource.datastreams['Advanced.jpg'])
        expect(obj.location).to eq(url + "advanced/" + pid)
      end
    end

    context "with a thumbnail stream" do
      it "translates and saves the image path to @location" do
        obj = FedoraHelpers::ImageDatastream.new(resource.datastreams['Thumbnail.png'])
        expect(obj.location).to eq(url + "thumb/" + pid)
      end
    end

    context "with an invalid stream" do
      it "saves an empty string to @location" do
        obj = FedoraHelpers::ImageDatastream.new({})
        expect(obj.location).to eq("")
      end
    end # End context "with an invalid stream"
  end # End describe "initialization"

end
