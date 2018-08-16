require 'rails_helper'

RSpec.describe Tufts::TdlResource do
  it "has a valid factory" do
    expect(FactoryBot.build(:tdl_resource)).to be_valid
  end

  it "is invalid with a bad url - and catches the exception" do
    expect(FactoryBot.build(:tdl_resource, url: "booo")).not_to be_valid
  end
end
