# @file
# Tests that the display from CatalogController actually matches fedora_fields.yml
# This file uses a lot of FedoraFieldMacros

require 'rails_helper'
include FedoraHelpers::ConfigParser
include FedoraFieldMacros

feature "ConfigParser fields display" do

  before(:all) do
    set_fedora_settings("config/fedora_fields.yml")
    # Can't use let() because it doesn't work in before(:all) scope.
    @exhibit = FactoryGirl.create(:exhibit)
    @resource = FactoryGirl.create(:fedora_resource, exhibit: @exhibit)
    @resource.reindex
  end

  after(:all) do
    @exhibit.destroy
    @resource.destroy
    clean_solr
  end

  before(:each) do
    visit(spotlight.exhibit_root_path(@exhibit))
    find_button(id: "search").click
  end

  scenario "Checking facet fields" do
    config_fields = get_field_names(get_facet_fields)
    displayed_fields = get_element_texts("#facets .panel h3")

    expect(config_fields).to eq(displayed_fields)
  end

  scenario "Checking index fields" do
    config_fields = get_field_names(get_index_fields) { |name| name + ":" }
    displayed_fields = get_element_texts("#documents .document dt")

    expect(config_fields).to eq(displayed_fields)
  end

  scenario "Checking show fields" do
    first("#documents .document h3 a").click

    config_fields = get_field_names(get_index_fields+get_show_fields) { |name| name + ":" }
    displayed_fields = get_element_texts("#document dt")

    expect(config_fields).to eq(displayed_fields)
  end

end

