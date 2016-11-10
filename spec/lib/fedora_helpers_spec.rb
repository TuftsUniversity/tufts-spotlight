require 'rails_helper'

shared_examples_for FedoraHelpers do
  let(:pid) { "tufts:MS054.003.DO.02108" }

  describe "load_resource" do
    let(:obj) { described_class.new("blah") }

    context "with a valid ID" do
      it "saves an ActiveFedora object in @fedora_object" do
        obj.load_resource(pid)
        expect(obj.instance_variable_get(:@fedora_object).class).to eq(ActiveFedora::Base)
      end
    end

    context "with an invalid ID" do
      it "saves an empty hash in @fedora_object" do
        obj.load_resource("fake")
        expect(obj.instance_variable_get(:@fedora_object)).to be_empty
      end
    end
  end

  describe "get_stream" do
    let(:obj) do
      obj = described_class.new("blah")
      obj.load_resource(pid)
      obj
    end
    let(:xml_ds) { "DCA-META" }
    let(:img_ds) { "Thumbnail.png" }

    context "with a valid datastream" do
      it "saves new stream to @streams" do
        obj.get_stream(xml_ds)
        expect(obj.instance_variable_get(:@streams)).to have_key(xml_ds.to_sym)
      end

      it "doesn't update @streams if key already exists" do
        obj.instance_variable_set(:@streams, { xml_ds.to_sym => "different value" } )
        expect(obj.get_stream(xml_ds)).to eq("different value")
      end

      context "with an XML Datastream" do
        it "returns FedoraHelpers::XMLDatastream object" do
          expect(obj.get_stream(xml_ds).class).to eq(FedoraHelpers::XMLDatastream)
        end
      end

      context "with an image datastream" do
        it "returns FedoraHelpers::ImageDatastream object" do
          expect(obj.get_stream(img_ds).class).to eq(FedoraHelpers::ImageDatastream)
        end
      end
    end #End context with a valid datastream

    context "with an invalid datastream" do
      it "returns nil" do
        expect(obj.get_stream("alskdjfa;sk")).to be_nil
      end

      it "saves nothing to @streams" do
        obj.get_stream("adsfasdf")
        expect(obj.instance_variable_get(:@streams)).to be_empty
      end
    end # End context with an invalid datastream
  end # End describe get_stream

end

