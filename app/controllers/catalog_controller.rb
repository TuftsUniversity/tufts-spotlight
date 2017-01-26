##
# Simplified catalog controller
class CatalogController < ApplicationController
  include Blacklight::Catalog

  configure_blacklight do |config|
          config.show.oembed_field = :oembed_url_ssm
          config.show.partials.insert(1, :oembed)

    config.view.gallery.partials = [:index_header, :index]
    config.view.masonry.partials = [:index]
    config.view.slideshow.partials = [:index]


    config.show.tile_source_field = Spotlight::Engine.config.full_image_field
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
    mppr = Solrizer::FieldMapper.new
    fed_flds = YAML::load(File.open(Rails.root.join('config/fedora_fields.yml'))).deep_symbolize_keys!
    fed_flds[:streams].each do |name, props|
      props[:elems].each do |el|
        if(el[:name].nil?)
          name = el[:field]
          label = name.capitalize
        else
          label = el[:name]
          name = el[:name].tr(' ', '_')
        end
        solr_field = mppr.solr_name(name, :stored_searchable, type: :string)
        if(el[:results])
          config.add_index_field solr_field, label: label
        else
          config.add_show_field solr_field, label: label
        end

        if(el[:facet])
          facet_field = mppr.solr_name(name, :facetable, type: :string)
          config.add_facet_field facet_field, label: label
        end
      end # props.each
    end # fed_flds.each

    config.add_search_field 'all_fields', label: 'Everything'

    config.add_sort_field 'relevance', sort: 'score desc', label: 'Relevance'


    config.add_field_configuration_to_solr_request!

    config.add_facet_field 'spotlight_upload_date_tesim', label: 'Date', limit: 7
    config.add_facet_fields_to_solr_request!
  end

  def guest_username_authentication_key key
    "spotlight_guest_" + guest_user_unique_suffix
  end

end
