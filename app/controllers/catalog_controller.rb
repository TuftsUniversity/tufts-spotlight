# frozen_string_literal: true

##
# Simplified catalog controller
class CatalogController < ApplicationController
  include Blacklight::Catalog
  include Blacklight::DefaultComponentConfiguration

  configure_blacklight do |config|
    config.show.oembed_field = :oembed_url_ssm
    config.show.partials.insert(1, :oembed)

    # Needed for blacklight-galary
    config.view.gallery.document_component = Blacklight::Gallery::DocumentComponent
    config.view.masonry.document_component = Blacklight::Gallery::DocumentComponent
    config.view.slideshow.document_component = Blacklight::Gallery::SlideshowComponent

    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    config.show.partials.insert(1, :universal_viewer_default)
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

    config.add_index_field('creator_tesim', label: 'Creator')
    config.add_index_field('description_tesim', label: 'Description')
    config.add_index_field('publisher_tesim', label: 'Publisher')
    config.add_index_field('date_tesim', label: 'Date')
    config.add_index_field('type_tesim', label: 'Type')

    config.add_show_field('creator_tesim', label: 'Creator')
    config.add_show_field('description_tesim', label: 'Description')
    config.add_show_field('publisher_tesim', label: 'Publisher')
    config.add_show_field('date_tesim', label: 'Date')
    config.add_show_field('subject_tesim', label: 'Subject')
    config.add_show_field('type_tesim', label: 'Type')
    config.add_show_field('format_tesim', label: 'Format')
    config.add_show_field('rights_tesim', label: 'Rights')
    config.add_show_field('corporation_tesim', label: 'Corporation')
    config.add_show_field('area_of_interest_tesim', label: 'Area of Interest')
    config.add_show_field('citation_tesim', label: 'Citation')
    config.add_show_field('permanent_url_tesim', label: 'Permanent URL', helper_method: 'make_this_a_link')

    config.add_search_field 'all_fields', label: I18n.t('spotlight.search.fields.search.all_fields')

    config.add_sort_field 'relevance', sort: 'score desc', label: I18n.t('spotlight.search.fields.sort.relevance')

    config.add_field_configuration_to_solr_request!

    config.add_facet_field('creator_sim', label: 'Creator')
    config.add_facet_field('publisher_sim', label: 'Publisher')
    config.add_facet_field('date_sim', label: 'Date')
    config.add_facet_field('subject_sim', label: 'Subject')
    config.add_facet_field('type_sim', label: 'Type')
    config.add_facet_field('format_sim', label: 'Format')
    config.add_facet_field('corporation_sim', label: 'Corporation')
    config.add_facet_field('area_of_interest_sim', label: 'Area of Interest')
    config.add_facet_field 'spotlight_upload_date_tesim', label: 'Date', limit: 7

    config.add_facet_fields_to_solr_request!

    # new blacklight configure for version 7
    config.add_results_document_tool(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)

    config.add_show_tools_partial(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)
    config.add_show_tools_partial(:email, callback: :email_action, validator: :validate_email_params)
    config.add_show_tools_partial(:sms, if: :render_sms_action?, callback: :sms_action, validator: :validate_sms_params)
    config.add_show_tools_partial(:citation)

    config.add_nav_action(:bookmark, partial: 'blacklight/nav/bookmark', if: :render_bookmarks_control?)
    config.add_nav_action(:search_history, partial: 'blacklight/nav/search_history')

    # enable facets:
    # https://github.com/projectblacklight/spotlight/issues/1812#issuecomment-327345318
    config.add_facet_fields_to_solr_request!
  end
end
