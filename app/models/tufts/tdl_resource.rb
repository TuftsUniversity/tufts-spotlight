# frozen_string_literal: true

module Tufts
  ##
  # @class
  # TdlResource is a slightly customized IIIF resource.
  class TdlResource < Spotlight::Resources::IiifHarvester
    ##
    # @function
    # Overrides Spotlight::Resources::IiifHarvester.iiif_manifests
    #
    # Uses our custom IiifService.
    def iiif_manifests
      @iiif_manifests ||= Tufts::IiifService.parse(url)
    end

    ##
    # @function
    # Overrides Spotlight::Resources::IiifHarvester.url_is_iiif?
    #
    # Wrapping super function in exception handling,
    #   so users don't see uncaught exceptions if the url is bad.
    def url_is_iiif?(url)
      super
    rescue StandardError
      false
    end

    # need to override this to have solr car
    def self.indexing_pipeline
      @indexing_pipeline ||= super.dup.tap do |pipeline|
        # pipeline.transforms = [Spotlight::Etl::Transforms::SourceMethodTransform(:solr_doc)] + pipeline.transforms
        # maybe I add a new sources?
        pipeline.sources = [Spotlight::Etl::Sources::SourceMethodSource(:iiif_manifests), Spotlight::Etl::Transforms::SourceMethodTransform(:solr_doc)]

        pipeline.transforms = [
          ->(data, p) { data.merge(p.source.to_solr(exhibit: p.context.resource.exhibit)) },

        ] + pipeline.transforms

        # pipeline.transforms = [
        #   ->(data, p) { data.merge(p.source.to_solr(exhibit: p.context.resource.exhibit)) },
        #   ->(data, p) { data.merge({ p.context.document_model.unique_key.to_sym => p.source.compound_id }) },
        #     Spotlight::Etl::Transforms::SourceMethodTransform(:solr_doc)
        # ] + pipeline.transforms
        Rails.logger.info "Indexing pipleline step for tdl_reasource"
      end
    end

    # to code bleow no longer works

    ##
    # @function
    # Retrieves the SolrDocument id via the shared sidecar.
    def doc_id
      sidecar.document_id
    end

    ##
    # @function
    # An easy way to get to the SolrDocument created from this resource.
    def solr_doc
      SolrDocument.find(doc_id)
    end

    ##
    # @function
    # An easy way to get to the SolrDocumentSidecar of this resource.
    def sidecar
      solr_document_sidecars.find_by(exhibit_id: exhibit_id)
    end
  end
end
