## @file
# Methods to parse the fedora_fields config file.

module FedoraHelpers
  ##
  # Loads the yaml file. Does some fancy stuff with it
  module ConfigParser

    ##
    # Translates a yaml file into a hash and returns it.
    # Paths that start with / will be take verbatim, otherwise concat'd to Rails.root.
    #
    # Available as either class or instance method.
    #
    # @param {string} file
    #   The file to load.
    def load_yaml(file)
      # Load the yaml file or error out informatively.
      begin
        unless(file[0] == "/")
          file = Rails.root.join(file).to_s
        end
        YAML::load(File.open(file)).deep_symbolize_keys![Rails.env.to_sym]
      rescue
        raise "Unable to load #{file}!"
      end
    end
    module_function(:load_yaml)


    ##
    # Retrieves all fields for show in the config file.
    def get_show_fields
      select_fields(lambda { |e| e[:results].nil? })
    end

    ##
    # Retrieves all index fields to show in search results from config file.
    def get_index_fields
      select_fields(lambda { |e| e.key?(:results) })
    end

    ##
    # Retrieves all facet fields from config file.
    def get_facet_fields
      select_fields(lambda { |e| e.key?(:facet) })
    end


    private

    ##
    # Sets fedora_settings instance variable, using load_yaml.
    #
    # @param {string} file
    #   The file to load.
    def set_fedora_settings(file)
      @fedora_settings = load_yaml(file)
    end

    ##
    # Returns a set of elements, selected by custom lamba.
    #
    # @param {lambda} filter
    #   A lambda filter to choose specific elements.
    # @return {array}
    #   The filtered element list.
    def select_fields(filter)
      fields = []
      @fedora_settings[:streams].each do |name, props|
        props[:elems].select(&filter).each { |e| fields.push(e) }
      end

      fields
    end


  end #End ConfigParser
end #End FedoraHelpers
