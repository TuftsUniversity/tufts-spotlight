## @file
# Helper methods for Image Datastreams

module FedoraHelpers

  ##
  # Image specific helpers.
  class ImageDatastream
    # The location of the image.
    attr_reader :location

    ##
    # Other Instance Vars
    # @base_url {string} The base_url of the image location.


    ##
    # Saves the image location to @location.
    #
    # @params
    #   stream {ActiveFedora::Datastream} Datastream to parse.
    def initialize(stream)
      @base_url = "https://dl.tufts.edu/file_assets/"

      unless(stream.respond_to?(:content))
        @location = ""
        Rails.logger.warn("Error, #{stream} is not a datastream.")
      else
        @location = translate(stream)
      end
    end


    private

    ##
    # Translates the bucket url to the dl url.
    #
    # @params
    #   stream {ActiveFedora::Datastream} Datastream to parse.
    def translate(stream)
      case(stream.dsid)
      when "Advanced.jpg"
        mid_url = "advanced/"
      when "Thumbnail.png"
        mid_url = "thumb/"
      when "Basic.jpg"
        mid_url = "medium/"
      else
        return ""
      end

      @base_url + mid_url + stream.pid
    end

  end # End class ImageDatastream
end
