class FedoraBuilder < Spotlight::SolrDocumentBuilder
  def to_solr
    return to_enum(:to_solr) unless block_given?

    # TODO: your implementation here
    # yield { id: resource.id }
  end
end
