require 'rails_helper'

RSpec.describe FedoraResource do
  let(:pid) { "tufts:MS054.003.DO.02108" }

  it "is valid with a good pid" do
    good = FedoraResource.new(url: pid)
    expect(good).to be_valid
  end

  it "is invalid with a bad pid" do
    bad = FedoraResource.new(url: "boooooo")
    expect(bad).not_to be_valid
  end
end
