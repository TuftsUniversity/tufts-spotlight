# frozen_string_literal: true

module Tufts
  class IiifService < Spotlight::Resources::IiifService
    ##
    # @function
    # Overrides Spotlight::Resources::IiifService.create_iiif_manifest
    #
    # Use the Tufts custom IIIF Manifest implementation.
    def create_iiif_manifest(manifest, collection = nil)
      Tufts::IiifManifest.new(url: manifest['@id'], manifest: manifest, collection: collection)
    end
  end
end
