require 'solrizer'
require 'yaml'

class FedoraBuilder < Spotlight::SolrDocumentBuilder
  include FedoraHelpers

  ##
  # Loads the YAML file and sets the default_ns.
  #
  # @param {FedoraResource}
  #   The resource coming from the insert form.
  def initialize(resource, settings_file = "config/fedora_fields.yml")
    super(resource)
    load_yaml(settings_file)
    if(@settings.key?(:default_ns))
      @default_ns = "#{@settings[:default_ns]}:"
    else
      @default_ns = ""
    end
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
  end


  private

  ##
  # Load the fedora_fields.yml file.
  def load_yaml(file)
    # Load the yaml file or error out informatively.
    begin
      unless(file[0] == "/")
        file = Rails.root.join(file).to_s
      end
      @settings = YAML::load(File.open(file)).deep_symbolize_keys!
    rescue
      raise "Unable to find fedora_fields.yml file!"
    end
  end

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
    get_stream(f[:ds]).get_text(f[:xpath])
  end

  ##
  # Add a field to the doc.
  #
  # @param {FedoraHelpers::XMLDatastream} stream
  #   The datastream that contains the element.
  # @param {hash} el
  #   A hash with :field and optionally :ns values.
  def insert_field(stream, el)
    xpath = build_xpath(el)
    Solrizer.insert_field(
      @doc,
      el.key?(:name) ? el[:name] : el[:field],
      stream.get_all_text(xpath),
      :stored_searchable
    )
  end

  ##
  # Builds the xpath expression to run through nokogiri.
  #
  # @param {hash} el
  #   A hash with :field and optionally :ns values.
  def build_xpath(el)
    if(["/", "@"].include?(el[:field][0]))
      ns = ""
    elsif(el.key?(:ns))
      ns = "#{el[:ns]}:"
    else
      ns = @default_ns
    end

    "#{ns}#{el[:field]}"
  end

end
