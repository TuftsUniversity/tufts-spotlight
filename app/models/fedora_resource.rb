class FedoraResource < Spotlight::Resource
  validates :url, valid_pid: true

  self.document_builder_class = FedoraBuilder
end
