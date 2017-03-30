# @file
# Tests that the display from CatalogController actually matches fedora_fields.yml

require 'rails_helper'
include FedoraHelpers::ConfigParser

feature "ConfigParser fields display" do

  before(:all) do
    set_fedora_settings("config/fedora_fields.yml")
    @exhibit = FactoryGirl.create(:exhibit)
    FactoryGirl.create(:fedora_resource, exhibit: @exhibit).reindex
  end

  before(:each) do
    visit(spotlight.exhibit_root_path(@exhibit))
    find_button(id: "search").click
  end

  scenario "Checking facet fields" do
    config_fields = []
    displayed_fields = []

    get_facet_fields.each do |f|
      if(f[:name].nil?)
        config_fields << f[:field].capitalize
      else
        config_fields << f[:name]
      end
    end

    all("#facets .panel h3").each do |el|
      if(el.text)
        displayed_fields << el.text
      end
    end

    expect(config_fields).to eq(displayed_fields)
  end

  scenario "Checking index fields" do
    config_fields = []
    displayed_fields = []

    get_index_fields.each do |f|
      if(f[:name].nil?)
        config_fields << f[:field].capitalize + ":"
      else
        config_fields << f[:name] + ":"
      end
    end

    all("#documents .document dt").each do |el|
      if(el.text)
        displayed_fields << el.text
      end
    end

    expect(config_fields).to eq(displayed_fields)
  end

  scenario "Checking show fields" do
    first("#documents .document h3 a").click

    config_fields = []
    displayed_fields = []

    get_index_fields.each do |f|
      if(f[:name].nil?)
        config_fields << f[:field].capitalize + ":"
      else
        config_fields << f[:name] + ":"
      end
    end

    get_show_fields.each do |f|
      if(f[:name].nil?)
        config_fields << f[:field].capitalize + ":"
      else
        config_fields << f[:name] + ":"
      end
    end

    all("#document dt").each do |el|
      if(el.text)
        displayed_fields << el.text
      else
        puts el
      end
    end

    expect(config_fields).to eq(displayed_fields)
  end

end

