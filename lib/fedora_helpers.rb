##
# @file
# Helper methods for working with Fedora and ActiveFedora

module FedoraHelpers

  ##
  # @properties
  #   fedora_object - The ActiveFedora Object.
  #   streams - The datastreams, saved after initial load.

  def find(id)
    if(ActiveFedora::Base.exists?(id))
      @fedora_object = ActiveFedora::Base.find(id)
      Rails.logger.info("Successfully loaded " + id)
    else
      Rails.logger.warn(id + "is not a valid Fedora ID!")
      @fedora_object = {}
    end
  end


  ##
  # Datastream-specific helpers.
  class Datastream
  end
end
