# frozen_string_literal: true
#@file
# Patches for Spotlight::Resources::Upload model

require_dependency Spotlight::Engine.root.join('app', 'models', 'spotlight', 'resources', 'upload').to_s

module Spotlight
  module Resources
    class Upload < Spotlight::Resource
      # Patch in our special Indexer
      self.document_builder_class = Tufts::UploadSolrDocumentBuilder
    end
  end
end
