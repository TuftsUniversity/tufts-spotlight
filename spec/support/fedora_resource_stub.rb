## @file
# Contains our fake submission for use in testing.

##
# The stub that represents a resource object coming
# from spotlight.
class FedoraResourceStub < FedoraResource
  def url
    "tufts:MS054.003.DO.02108"
  end

  # Usually this is pulled from the exhibit, but the stub has no exhibit.
  def document_model
    SolrDocument
  end
end
