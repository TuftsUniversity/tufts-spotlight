module Tufts
  class TdlResource < Spotlight::Resources::IiifHarvester

    # No customizations needed for builder - still using Spotlight's builder.
    self.document_builder_class = Spotlight::Resources::IiifBuilder

    ##
    # @function
    # Using our custom IiifService.
    def iiif_manifests
      @iiif_manifests ||= Tufts::IiifService.parse(url)
    end
  end
end