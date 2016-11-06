require 'solrizer'
require 'yaml'

class FedoraBuilder < Spotlight::SolrDocumentBuilder
  include FedoraHelpers

  def initialize(resource)
    super(resource)
    @streams = {}
    load_yaml
  end

  def to_solr
    return to_enum(:to_solr) unless block_given?

    # Get the fedora resource and its pid.
    @fedora_object = ActiveFedora::Base.find(@resource.url)
    dcStrm = @fedora_object.datastreams["DCA-META"]

    # Parse the xml.
    @xml = Nokogiri::XML(dcStrm.content.to_s)
    @root = "/dca_dc:dc/"

    # Start the output hash.
    pid = dcStrm.pid
    id = dcStrm.pid.gsub(/^.*:/, '').gsub('.', '')
    doc = {
      id: id,
      full_title_tesim: full_title_field(),
      spotlight_resource_type_ssim: "spotlight/resources/fedora",
      f3_pid_ssi: pid
    }

    # Fill the rest of the output hash.
    field_names().each do |h|
      Solrizer.insert_field(
        doc,
        h[:field],
        aggregate_fields(build_xpath(h)),
        :stored_searchable
      )
    end

    unless(@fedora_object.datastreams["Advanced.jpg"].nil?)
      doc[Spotlight::Engine.config.full_image_field] =
        @fedora_object.datastreams["Advanced.jpg"].dsLocation

      doc = add_image_dimensions(doc)
    end

    unless(@fedora_object.datastreams["Thumbnail.png"].nil?)
      doc[Spotlight::Engine.config.thumbnail_field] =
        @fedora_object.datastreams["Thumbnail.png"].dsLocation
    end

    yield doc

    # TODO: your implementation here
    # yield { id: resource.id }
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
    byebug
    ds = @fedora_object.datastreams[f[:ds]]
    ds.xpath(f[:xpath]).first.text
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

  ##
  # Iterates over an element list and gets each text value.
  #
  # @param {string} xpath
  #   The xpath to use with nokogiri.
  def aggregate_fields(xpath)
    values = []
    elements = @xml.xpath(xpath)
    elements.each do |el|
      values.push(el.text)
    end

    values
  end

  ##
  # Converts a datastream to Nokogiri.
  # Caches the stream to @streams.
  def parse_stream(ds)
    dsym = ds.to_sym
    unless(@streams.key?(dsym))
      @streams[dsym] = Nokogiri::XML(@fedora_object.datastreams[ds])
    end
    @streams[dsym]
  end

end
