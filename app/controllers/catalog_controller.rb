##
# Simplified catalog controller
class CatalogController < ApplicationController
  include Blacklight::Catalog
  extend FedoraHelpers::ConfigParser

  ##
  # Adds a field to blacklight, either index, show or facet.
  #
  # @params
  #   el_hash {hash} A single element's hash from the yml file.
  #   display_type {sym} :index, :show, or :facet.
  #   mapper {obj} A Solrizer::FieldMapper.
  def self.get_field_values(el_hash, display_type, mapper)
    if(el_hash[:name].nil?)
      name = el_hash[:field]
      label = name.capitalize
    else
      label = el_hash[:name]
      name = label.tr(" ", "_").downcase
    end

    solr_index_type = display_type == :facet ? :facetable : :stored_searchable
    solr_field = mapper.solr_name(name, solr_index_type, type: :string)

    yield(solr_field, label)
  end

  configure_blacklight do |config|
    ## Remove?
    # These document actions currently don't work. Will readd when they are fixed.
    #config.show.document_actions.delete(:citation)
    #config.show.document_actions.delete(:email)
    #config.show.document_actions.delete(:sms

    config.show.oembed_field = :oembed_url_ssm
    config.show.partials.insert(1, :oembed)

    config.view.gallery.partials = [:index_header, :index]
    config.view.masonry.partials = [:index]
    config.view.slideshow.partials = [:index]


    # Old, pre-iiif image handling
    #config.show.tile_source_field = Spotlight::Engine.config.full_image_field
    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    config.show.partials.insert(1, :openseadragon)
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qt: 'search',
      rows: 10,
      fl: '*'
    }

    config.document_solr_path = 'get'
    config.document_unique_id_param = 'ids'

    # solr field configuration for search results/index views
    config.index.title_field = 'full_title_tesim'

    # Propagating solr fields from fedora_fields.yml
    set_fedora_settings("config/fedora_fields.yml")
    mppr = Solrizer::FieldMapper.new

    # Do the index fields first
    get_index_fields.each do |el|
      get_field_values(el, :index, mppr) do |field, label|
        config.add_index_field(field, label: label)
        Rails.logger.info("Adding index field: #{label} - #{field}")
      end
    end

    # config.add_indexfield("creator_tesim", label: "Creator")
    # config.add_index_field("description_tesim", label: "Description")
    # config.add_index_field("publisher_tesim", label: "Publisher")
    # config.add_index_field("date_tesim", label: "Date")
    # config.add_index_field("type_tesim", label: "Type")

    # Do the show fields next
    get_show_fields.each do |el|
      get_field_values(el, :show, mppr) do |field, label|
        config.add_show_field(field, label: label)
        Rails.logger.info("Adding show field: #{label} - #{field}")
      end
    end

    # config.add_show_field("creator_tesim", label: "Creator")
    # config.add_show_field("description_tesim", label: "Description")
    # config.add_show_field("publisher_tesim", label: "Publisher")
    # config.add_show_field("date_tesim", label: "Date")
    # config.add_show_field("subject_tesim", label: "Subject")
    # config.add_show_field("type_tesim", label: "Type")
    # config.add_show_field("format_tesim", label: "Format")
    # config.add_show_field("rights_tesim", label: "Rights")
    # config.add_show_field("corporation_tesim", label: "Corporation")
    # config.add_show_field("area_of_interest_tesim", label: "Area of Interest")
    # config.add_show_field("citation_tesim", label: "Citation")
    # config.add_show_field("permanent_url_tesim", label: "Permanent URL")

    config.add_search_field 'all_fields', label: 'Everything'

    config.add_sort_field 'relevance', sort: 'score desc', label: 'Relevance'

    config.add_field_configuration_to_solr_request!

    # Do the facet fields last
    get_facet_fields.each do |el|
      get_field_values(el, :facet, mppr) do |field, label|
        config.add_facet_field(field, label: label)
        Rails.logger.info("Adding facet field: #{label} - #{field}")
      end
    end

    # config.add_facet_field("creator_sim", label: "Creator")
    # config.add_facet_field("publisher_sim", label: "Publisher")
    # config.add_facet_field("date_sim", label: "Date")
    # config.add_facet_field("subject_sim", label: "Subject")
    # config.add_facet_field("type_sim", label: "Type")
    # config.add_facet_field("format_sim", label: "Format")
    # config.add_facet_field("corporation_sim", label: "Corporation")
    # config.add_facet_field("area_of_interest_sim", label: "Area of Interest")
    config.add_facet_field 'spotlight_upload_date_tesim', label: 'Date', limit: 7

    config.add_facet_fields_to_solr_request!
  end

end

