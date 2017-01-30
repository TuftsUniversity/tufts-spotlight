## @file
# Methods to parse the fedora_fields config file.

module FedoraHelpers

  ##
  # Loads the yaml file. Does some fancy stuff with it
  module ConfigParser

    ##
    # Load the fedora_fields.yml file.
    def self.load_yaml(file)
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
    def load_yaml(file)
      self.load_yaml(file)
    end


  end
end
