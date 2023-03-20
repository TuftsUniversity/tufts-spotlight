# frozen_string_literal: true

# @file
# Monkey patch for SolrDocumentSidecar.
# Fixes issue where empty custom fields were displaying in search results and show view.
# https://github.com/projectblacklight/spotlight/issues/2070
require_dependency Spotlight::Engine.root.join('app', 'models', 'spotlight', 'solr_document_sidecar').to_s

module Spotlight
  class SolrDocumentSidecar < ActiveRecord::Base
    def custom_fields_data_to_solr
      data.except('configured_fields').each_with_object({}) do |(key, value), solr_hash|
        next if value.blank? ## PATCH HERE ##

        custom_field = custom_fields[key]
        field_name = custom_field.solr_field if custom_field
        field_name ||= key
        solr_hash[field_name] = value
      end
    end
  end
end
