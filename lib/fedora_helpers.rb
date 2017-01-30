## @file
# Helper methods for working with Fedora, ActiveFedora, and Nokogiri

module FedoraHelpers

  ##
  # @properties
  #   fedora_object - The ActiveFedora Object.
  #   streams - The datastreams, saved after initial load.


  ##
  # Saves a Fedora record into @fedora_object.
  # Saves an empty hash if record not found.
  #
  # @params
  #   id {string} Fedora pid.
  def load_resource(id)
    if(ActiveFedora::Base.exists?(id))
      @fedora_object = ActiveFedora::Base.find(id)
      Rails.logger.info("Successfully loaded #{id}.")
    else
      @fedora_object = {}
      Rails.logger.warn("#{id} is not a valid Fedora ID!")
    end
  end

  ##
  # Retrieves a specific datastream, wrapped in FedoraHelpers::Datastream class.
  # Datastreams are saved to @streams, so we don't keep reloading them.
  #
  # @params
  #   name {string} Datastream name.
  # @return {FedoraHelpers::Datastream / hash}
  #   FedoraHelpers::Datastream object or empty hash.
  def get_stream(name)
    if(@streams.nil?)
      @streams = {}
    end

    if(@fedora_object.datastreams.key?(name))
      nym = name.to_sym
      unless(@streams.key?(nym))
        prepare_stream(name)
      end
      @streams[nym]
    else
      Rails.logger.warn("#{name} is not a valid datastream!")
      nil
    end
  end


  private

  ##
  # Figures out the stream type and loads it into the appropriate Datastream Class.
  # Saves the datastream to @streams, for future use.
  #
  # @params
  #   name {string} Datastream name.
  def prepare_stream(name)
    nym = name.to_sym
    ds = @fedora_object.datastreams[name]
    if(ds.mimeType == "text/xml")
      @streams[nym] = FedoraHelpers::XMLDatastream.new(ds)
    elsif(/image/.match(ds.mimeType))
      @streams[nym] = FedoraHelpers::ImageDatastream.new(ds)
    else
      Rails.logger.warn("#{name} is not an XML or image datastream!")
    end
  end
end # End FedoraHelpers

