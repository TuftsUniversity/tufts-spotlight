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
  def find(id)
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
        @streams[nym] =
          FedoraHelpers::Datastream.new(@fedora_object.datastreams[name])
      end
      @streams[nym]
    else
      Rails.logger.warn("#{name} is not a valid datastream!")
      nil
    end
  end


  ##
  # Datastream-specific helpers.
  class Datastream
    # Our Nokogiri::XML document.
    attr_reader :xml
    # Our default root element to work from.
    attr_accessor :default_root
    # The Fedora 3 Pid
    attr_reader :pid

    ##
    # Loads the xml into @xml.
    #
    # @params
    #   stream {ActiveFedora::Datastream} Datastream to parse.
    def initialize(stream)
      unless(stream.respond_to?(:content))
        @xml = ""
        Rails.logger.warn("Error, #{stream} is not a datastream.")
      else
        @xml = Nokogiri::XML(stream.content.to_s)
        @default_root = "/#{get_root}"
        @pid = stream.pid
      end
    end

    ##
    # Gets the root node name and namespace.
    #
    # @return {string}
    #   Root node name, with namespace.
    def get_root
      get_full_node_name(@xml.root)
    end

    ##
    # Gets the text from the first element that matches xpath.
    #
    # @params
    #   path {string} Element name or path to search for.
    # @return {string}
    #   The text from the element or "".
    def get_text(path)
      elements = xpath(path)
      if(elements.empty?)
        ""
      else
        elements.first.text
      end
    end

    ##
    # Gets an array of all the texts from elements that match xpath.
    #
    # @params
    #   path {string} Element name or path to search for.
    # @return {array}
    #   An array of the text values of all the matching elements.
    def get_all_text(path)
      values = []
      elements = xpath(path)
      elements.each do |el|
        values.push(el.text)
      end
      values
    end


    private

    ##
    # Performs an xpath query.
    #
    # Paths that start with '/' will be taken verbatim.
    # Paths that don't will be concat'd to @default_root.
    #
    # @params
    #   path {string} Xpath string to search for.
    # @return {array}
    #   Set of elements that match the query.
    def xpath(path)
      unless(path[0] == "/")
        path = "#{@default_root}/#{path}"
      end

      begin
        @xml.xpath(path)
      rescue Nokogiri::XML::XPath::SyntaxError
        Rails.logger.warn("Syntax error searching for #{path}.")
        []
      end
    end

    ##
    # Gets the node name prefixed by its ns, if it has one.
    #
    # @params
    #   node {Nokogiri::XML::Element} Target element.
    # @return {string}
    #   Node name, with namespace if applicable.
    def get_full_node_name(node)
      if(node.namespace.prefix.to_s == "")
        element.name
      else
        "#{node.namespace.prefix}:#{node.name}"
      end
    end
  end # End Datastream

end # End FedoraHelpers

