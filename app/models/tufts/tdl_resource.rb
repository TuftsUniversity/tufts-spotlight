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
      begin
        super
      rescue StandardError
        false
      end
    end

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
      solr_document_sidecars.where(exhibit_id: exhibit_id).first
    end
  end
end
