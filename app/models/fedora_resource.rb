class FedoraResource < Spotlight::Resource
  validates :url, valid_pid: true

  def doc_id
    url.gsub(/^.*:/, '').gsub('.', '')
  end

  def solr_doc
    SolrDocument.find(doc_id)
  end

  def has_exhibit?
    !Spotlight::Exhibit.where(id: exhibit_id).empty?
  end

  def sidecar
   solr_document_sidecars.where(exhibit_id: exhibit_id).first ||
      Spotlight::SolrDocumentSidecar.where(document_id: doc_id, exhibit_id: exhibit_id).first
  end

  def sidecars_match?
    # Sidecars don't need to be attached to resource.
    if(self.solr_document_sidecars.empty?)
      puts "No sidecars on this resource."
      return true
    end

    doc_sidecars = Spotlight::SolrDocumentSidecar.where(document_id: doc_id, exhibit_id: exhibit_id)
    resource_sidecars = solr_document_sidecars.where(exhibit_id: exhibit_id)

    if(doc_sidecars.empty?)
      puts "No sidecars on Solr Doc: #{doc_id}"
      return false
    end

    doc_sidecars.first.id == resource_sidecars.first.id
  end

  self.document_builder_class = FedoraBuilder
end
