module Tufts
  class TdlResource < Spotlight::Resources::IiifHarvester

    # No customizations needed for builder. So still using Spotlight's builder.tdl
    self.document_builder_class = Spotlight::Resources::IiifBuilder

    ##
    # @function
    # Using our custom IiifService, over Spotlight stock one.
    def iiif_manifests
      @iiif_manifests ||= Tufts::IiifService.parse(url)
    end
  end
end