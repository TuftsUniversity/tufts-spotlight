class FedoraBuilder < Spotlight::SolrDocumentBuilder
  def to_solr
    return to_enum(:to_solr) unless block_given?

    id = @resource.url
    fedora_object = ActiveFedora::Base.find(id)
    dcStrm = fedora_object.datastreams["DCA-META"]
    dc = Nokogiri::XML(dcStrm.content.to_s)
    root = "/dca_dc:dc/dc:"
    id = /.*:(.*)/.match(dcStrm.pid)

    doc = {
      id: id[1],
      full_title_tesim: dc.xpath(root + "title").text,
      description_tesim: dc.xpath(root + "description").text
    }

    yield doc

    # TODO: your implementation here
    # yield { id: resource.id }
  end
end
