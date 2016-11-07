require 'rails_helper'

describe FedoraHelpers::Datastream do
  let(:pid) { "tufts:MS054.003.DO.02108" }
  let(:ds_name) { "DCA-META" }
  let(:stream) { ActiveFedora::Base.find(pid).datastreams[ds_name] }

  describe "initialization" do
    context "with a valid stream" do
      it "saves a Nokogiri document to @xml" do
        obj = FedoraHelpers::Datastream.new(stream)
        expect(obj.instance_variable_get(:@xml).class).to eq(Nokogiri::XML::Document)
      end
    end

    context "with an invalid stream" do
      it "saves an empty string to @xml" do
        obj = FedoraHelpers::Datastream.new({})
        expect(obj.instance_variable_get(:@xml)).to eq("")
      end
    end
  end # End describe initialization

end # End describe FedoraHelpers::Datastream
