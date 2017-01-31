## @file
# Methods to parse the fedora_fields config file.

module FedoraHelpers
  ##
  # Loads the yaml file. Does some fancy stuff with it
  module ConfigParser

    ##
    # Load the fedora_fields.yml file.
    def load_yaml(file)
      # Load the yaml file or error out informatively.
      begin
        unless(file[0] == "/")
          file = Rails.root.join(file).to_s
        end
        YAML::load(File.open(file)).deep_symbolize_keys!
      rescue
        raise "Unable to find #{file}!"
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
    def set_fedora_settings(file)
      @fedora_settings = load_yaml(file)
    end

    ##
    # Returns a set of elements, selected by custom proc.
    def select_fields(filter)
      fields = []
      @fedora_settings[:streams].each do |name, props|
        props[:elems].select(&filter).each { |e| fields.push(e) }
      end

      fields
    end


  end #End ConfigParser
end #End FedoraHelpers
