require 'solrizer'
require 'yaml'

class FedoraBuilder < Spotlight::SolrDocumentBuilder
  include FedoraHelpers

  ##
  # @properties
  #   settings - The fields and datastreams to import.
  #   doc - The output solr hash.
  #   fedora_object - ActiveFedora object, from FedoraHelpers.


  ##
  # Loads the YAML file.
  #
  # @param {FedoraResource} resource
  #   The resource coming from the insert form.
  # @param {string} settings_file
  #   The yaml file to use for meatadata settings.
  def initialize(resource, settings_file = "config/fedora_fields.yml")
    super(resource)
    @settings = FedoraHelpers::ConfigParser.load_yaml(settings_file)
  end

  ##
  # Builds the Solr hash.
  def to_solr
    # Get the fedora resource and its pid.
    load_resource(@resource.url)
    pid = @fedora_object.pid

    # Start the output hash.
    @doc = super.merge!({
      id: pid.gsub(/^.*:/, '').gsub('.', ''),
      full_title_tesim: full_title_field,
      spotlight_resource_type_ssim: "spotlight/resources/fedora",
      f3_pid_ssi: pid
    })

    # Fill the rest of the output hash with XML Datastream metadata.
    @settings[:streams].each do |name, props|
      stream = get_stream(name.to_s)
      unless(stream.nil?)
        props[:elems].each do |el|
          insert_field(stream, el)
        end
      end
    end

    # Add the url to our main image.
    unless(get_stream(@settings[:full_image]).nil?)
      @doc[Spotlight::Engine.config.full_image_field] =
        get_stream(@settings[:full_image]).location

      add_image_dimensions
    end

    # Add the url to the thumbnail.
    unless(get_stream(@settings[:thumb]).nil?)
      @doc[Spotlight::Engine.config.thumbnail_field] =
        get_stream(@settings[:thumb]).location
    end

    @doc
  end # End to_solr


  private

  ##
  # Add the image dimensions to solr doc.
  def add_image_dimensions
    # Speed up our tests by not doing the MiniMagick stuff.
    if(Rails.env == "test")
      @doc[:spotlight_full_image_width_ssm] = 1
      @doc[:spotlight_full_image_height_ssm] = 1
    else
      dimensions = ::MiniMagick::Image.open(@doc[Spotlight::Engine.config.full_image_field])[:dimensions]
      @doc[:spotlight_full_image_width_ssm] = dimensions.first
      @doc[:spotlight_full_image_height_ssm] = dimensions.last
    end
  end

  ##
  # The field to use for full_title_field.
  #
  # @return {string}
  #   The full title text.
  def full_title_field
    f = @settings[:full_title_field]
    get_stream(f[:ds]).get_text(f[:element][:field])
  end

  ##
  # Add a field to the doc.
  #
  # @param {FedoraHelpers::XMLDatastream} stream
  #   The datastream that contains the element.
  # @param {hash} el
  #   A hash with :field and optionally :name values.
  def insert_field(stream, el)
    values = stream.get_all_text(el[:field])

    # How are we indexing?
    indexer_args = [:stored_searchable]
    if(el[:facet])
      indexer_args.push(:facetable)
    end

    if(el.key?(:name))
      name = el[:name].tr(' ', '_')
    else
      name = el[:field]
    end

    Solrizer.insert_field(
      @doc,
      name,
      values,
      *indexer_args
    )
  end

end
