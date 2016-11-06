require 'rails_helper'

shared_examples_for 'FedoraHelpers' do
  let(:pid) { 'tufts:MS054.003.DO.02108' }

  describe "#find" do
    it "saves a valid ID as a record in @fedora_object" do
      valid = described_class.new(pid)
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

end

