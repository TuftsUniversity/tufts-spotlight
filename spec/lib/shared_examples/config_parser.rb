require 'rails_helper'

shared_examples_for FedoraHelpers::ConfigParser do
  skip "has instance access to load_yaml" do
    yaml = load_yaml("spec/fixtures/fedora_fields.yml")
    expect(yaml).to_not be_empty
  end
end

