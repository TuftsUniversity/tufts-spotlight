require 'rails_helper'

RSpec.describe FedoraResource do

  it "has a valid factory" do
    expect(FactoryGirl.build(:fedora_resource)).to be_valid
  end

  it "is invalid with a bad pid" do
    expect(FactoryGirl.build(:fedora_resource, url: "booo")).not_to be_valid
  end
end
