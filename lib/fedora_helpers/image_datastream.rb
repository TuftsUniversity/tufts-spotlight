## @file
# Helper methods for Image Datastreams

module FedoraHelpers

  ##
  # Image specific helpers.
  class ImageDatastream
    # The location of the image.
    attr_reader :location

    ##
    # Saves the image location to @location.
    #
    # @params
    #   stream {ActiveFedora::Datastream} Datastream to parse.
    def initialize(stream)
      unless(stream.respond_to?(:content))
        @location = ""
        Rails.logger.warn("Error, #{stream} is not a datastream.")
      else
        @location = stream.dsLocation
      end
    end
  end # End class ImageDatastream

end
