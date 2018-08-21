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
      rescue Faraday::ConnectionFailed
        false
      end
    end
  end
end