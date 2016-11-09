module Spotlight
  module SolrDocument
    ##
    # Mixin for SolrDocuments backed by exhibit-specific resources
    module FedoraResource
      extend ActiveSupport::Concern

      def to_openseadragon(*_args)
        unless(self[Spotlight::Engine.config.full_image_field].nil?)
          self[Spotlight::Engine.config.full_image_field].each_with_index.map do |image_url, index|
          { ImageTileSource.new(
            image_url,
            width: self[:spotlight_full_image_width_ssm][index],
            height: self[:spotlight_full_image_height_ssm][index]
          ) => {} }
          end
        end
      end

      ##
      # Stub legacy image pyramid property generators
      # From Spotlight::SolrDocument::UploadedResource
      class ImageTileSource
        attr_reader :to_tilesource
        def initialize(url, dimensions = {})
          @to_tilesource = {
            type: 'image',
            url: url,
            width: dimensions[:width],
            height: dimensions[:height]
          }
        end
      end # End class ImageTileSource

    end # End FedoraResource
  end # End SolrDocument
end # End Spotlight
