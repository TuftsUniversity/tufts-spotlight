##
# Saves a FedoraBuilder stub to a yaml file.
# Gives a little boost to the FedoraBuilder tests.
module FedoraBuilderCacheMaker

  ##
  # Settings
  #   @filepath {string} The full path to the file.
  #   @exhibit {Spotlight::Exhibit} The related, exhibit object.

  ##
  # Creates the yaml file, and exhibit in the db.
  #
  # @params
  #   filepath {string} The full path of the file to create.
  def create_builder_stub(filepath = "#{Rails.root}/tmp/fedora_builder_spec.yml")
    @filepath = filepath
    @exhibit = FactoryGirl.create(:exhibit)
    obj = FedoraBuilder.new(
      FactoryGirl.build_stubbed(:fedora_resource, exhibit: @exhibit)
    )
    f = File.new(@filepath, 'w')
    f.write(obj.to_yaml)
    f.flush
  end

  ##
  # Loads the yaml back into a stub, for use in FedoraBuilder tests.
  def load_builder_stub
    YAML::load(File.open(@filepath))
  end

  ##
  # Deletes the file, and the exhibit from the db.
  def delete_builder_stub
    @exhibit.delete
    FileUtils.rm(@filepath)
  end

end

