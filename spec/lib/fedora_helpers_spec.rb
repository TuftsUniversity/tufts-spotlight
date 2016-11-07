require 'rails_helper'

shared_examples_for 'FedoraHelpers' do
  let(:pid) { 'tufts:MS054.003.DO.02108' }

  describe "find" do
    context "with a valid ID" do
      it "saves an ActiveFedora object in @fedora_object" do
        valid = described_class.new("blah")
        valid.find(pid)
        expect(
          valid.instance_variable_get(:@fedora_object).class
        ).to eq(ActiveFedora::Base)
      end
    end

    context "with an invalid ID" do
      it "saves an empty hash in @fedora_object" do
        invalid = described_class.new("blah")
        invalid.find("blah")
        expect(invalid.instance_variable_get(:@fedora_object)).to be_empty
      end
    end
  end

  describe "get_stream" do
    let(:obj) do
      obj = described_class.new("blah")
      obj.find(pid)
      obj
    end
    let(:ds) { "DCA-META" }

    context "with a valid datastream" do
      it "returns FedoraHelpers::Datastream object" do
        expect(obj.get_stream(ds).class).to eq(FedoraHelpers::Datastream)
      end

      it "saves new stream to @streams" do
        obj.get_stream(ds)
        expect(obj.instance_variable_get(:@streams)).to have_key(ds.to_sym)
      end

      it "doesn't save to @streams if already there" do
        obj.instance_variable_set(:@streams, { ds.to_sym => "bad value" } )
        expect(obj.get_stream(ds)).to eq("bad value")
      end
    end

    context "with an invalid datastream" do
      it "returns nil" do
        expect(obj.get_stream("alskdjfa;sk")).to be_nil
      end

      it "saves nothing to @streams" do
        obj.get_stream("adsfasdf")
        expect(obj.instance_variable_get(:@streams)).to be_empty
      end
    end
  end

end

