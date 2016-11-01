require 'solrizer'

class FedoraBuilder < Spotlight::SolrDocumentBuilder

  def to_solr
    return to_enum(:to_solr) unless block_given?

    # Get the fedora resource and its pid.
    fedora_object = ActiveFedora::Base.find(@resource.url)
    dcStrm = fedora_object.datastreams["DCA-META"]

    # Parse the xml.
    @xml = Nokogiri::XML(dcStrm.content.to_s)
    @root = "/dca_dc:dc/"

    # Start the output hash.
    pid = dcStrm.pid
    id = dcStrm.pid.gsub(/^.*:/, '').gsub('.', '')
    doc = {
      id: id,
      full_title_tesim: @xml.xpath(@root + full_title_field).first.text,
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

    unless(fedora_object.datastreams["Basic.jpg"].nil?)
      doc[Spotlight::Engine.config.full_image_field] =
        fedora_object.datastreams["Basic.jpg"].dsLocation
    end

    unless(fedora_object.datastreams["Thumbnail.png"].nil?)
      doc[Spotlight::Engine.config.thumbnail_field] =
        fedora_object.datastreams["Thumbnail.png"].dsLocation
    end

    yield doc

    # TODO: your implementation here
    # yield { id: resource.id }
  end


  private

  ##
  # The field to use for full_title_field
  def full_title_field
    "dc:title"
  end

  ##
  # The fields and namespaces we're adding to the doc.
  def field_names
    [
      { field: "description" },
      { field: "creator" },
      { field: "publisher" },
      { field: "subject", ns: "dcadesc" }
    ]
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
end
