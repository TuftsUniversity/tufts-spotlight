require 'rails_helper'

shared_examples_for 'FedoraHelpers' do
  let(:pid) { 'tufts:MS054.003.DO.02108' }

  describe "find" do
    it "saves a valid ID as an ActiveFedora object in @fedora_object" do
      valid = described_class.new("blah")
      valid.find(pid)
      expect(
        valid.instance_variable_get(:@fedora_object).class
      ).to eq(ActiveFedora::Base)
    end

    it "saves an invalid ID as an empty hash in @fedora_object" do
      invalid = described_class.new("blah")
      invalid.find("blah")
      expect(invalid.instance_variable_get(:@fedora_object)).to be_empty
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

      it "saves stream to @streams if not already there"
      it "doesn't save stream to @streams if already there"
    end

    context "with an invalid datastream" do
      it "returns nil" do
        expect(obj.get_stream("alskdjfa;sk")).to be_nil
      end
      it "saves nothing to @streams"
    end
  end

end

