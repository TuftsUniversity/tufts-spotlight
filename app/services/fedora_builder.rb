require 'solrizer'
require 'yaml'

class FedoraBuilder < Spotlight::SolrDocumentBuilder
  include FedoraHelpers

  def initialize(resource)
    super(resource)
    load_yaml
  end

  def to_solr
    # Get the fedora resource and its pid.
    load_resource(@resource.url)
    pid = @fedora_object.pid

    # Start the output hash.
    doc = super.merge!({
      id: pid.gsub(/^.*:/, '').gsub('.', ''),
      full_title_tesim: full_title_field,
      spotlight_resource_type_ssim: "spotlight/resources/fedora",
      f3_pid_ssi: pid
    })

    # Fill the rest of the output hash.
    field_names.each do |h|
      Solrizer.insert_field(
        doc,
        h[:field],
        aggregate_fields(build_xpath(h)),
        :stored_searchable
      )
    end

    unless(get_stream("Advanced.jpg").nil?)
      doc[Spotlight::Engine.config.full_image_field] =
        get_stream("Advanced.jpg").location

      doc = add_image_dimensions(doc)
    end

    unless(get_stream("Thumbnail.png").nil?)
      doc[Spotlight::Engine.config.thumbnail_field] =
        get_stream("Thumbnail.png").location
    end

    doc

  end


  private

  ##
  # Load the fedora_fields.yml file.
  def load_yaml
    # Load the yaml file or error out informatively.
    begin
      @settings = YAML::load(File.open(Rails.root.join("config/fedora_fields.yml").to_s)).deep_symbolize_keys!
    rescue
      raise "Unable to find fedora_fields.yml file!"
    end
  end

  ##
  # Add the image dimensions to solr.
  def add_image_dimensions(doc)
    dimensions = ::MiniMagick::Image.open(doc[Spotlight::Engine.config.full_image_field])[:dimensions]
    doc[:spotlight_full_image_width_ssm] = dimensions.first
    doc[:spotlight_full_image_height_ssm] = dimensions.last
    doc
  end

  #
  # The field to use for full_title_field.
  def full_title_field
    f = @settings[:full_title_field]
    get_stream(f[:ds]).get_text(f[:xpath])
  end

  ##
  # The fields and namespaces we're adding to the doc.
  def field_names
    []
  end

  ##
  # Builds the xpath expression to run through nokogiri.
  #
  # @param {hash} fld_hsh
  #   A hash with :field and optionally :ns values.
  def build_xpath(fld_hsh)
    root = @root.nil? ? "/" : @root
    ns = fld_hsh.has_key?(:ns) ? fld_hsh[:ns] : "dc"

    root + ns + ":" + fld_hsh[:field]
  end

end
