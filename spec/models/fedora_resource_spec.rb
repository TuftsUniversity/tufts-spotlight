require 'rails_helper'

RSpec.describe FedoraResource do

  it "has a valid factory" do
    expect(FactoryBot.build(:fedora_resource)).to be_valid
  end

  it "is invalid with a bad pid" do
    expect(FactoryBot.build(:fedora_resource, url: "booo")).not_to be_valid
  end
end
