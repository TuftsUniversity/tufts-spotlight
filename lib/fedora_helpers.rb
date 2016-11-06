##
## @file
# Helper methods for working with Fedora and ActiveFedora

module FedoraHelpers

  ##
  # @properties
  #   fedora_object - The ActiveFedora Object.
  #   streams - The datastreams, saved after initial load.


  ##
  # Retrieves an ActiveFedora object, or {} if the pid's invalid.
  #
  # @params
  #   id {string} Fedora pid.
  #
  # @return {object/hash}
  #   ActiveFedora object or empty hash.
  def find(id)
    if(ActiveFedora::Base.exists?(id))
      @fedora_object = ActiveFedora::Base.find(id)
      Rails.logger.info("Successfully loaded " + id)
    else
      @fedora_object = {}
      Rails.logger.warn(id + " is not a valid Fedora ID!")
    end
  end

  ##
  # Retrieves a specific datastream, wrapped in FedoraHelpers::Datastream class."
  #
  # Datastreams are lazy-loaded to @streams.
  #
  # @params
  #   name {string} Datastream name.
  #
  # @return {object/hash}
  #   FedoraHelpers::Datastream object or empty hash.
  def get_stream(name)
    if(@streams.nil?)
      @streams = {}
    end

    if(@fedora_object.datastreams.key?(name))
      nym = name.to_sym
      unless(@streams.key?(nym))
        @streams[nym] = FedoraHelpers::Datastream.new(@fedora_object.datastreams[name])
      end
      @streams[nym]
    else
      Rails.logger.warn(name + " is not a valid datastream!")
      nil
    end
  end


  ##
  # Datastream-specific helpers.
  class Datastream
    def initialize(stream)
    end
  end
end
