# frozen_string_literal: true

module Tufts
  class UploadSolrDocumentBuilder < Spotlight::UploadSolrDocumentBuilder
    def to_solr
      super.tap do |solr_hash|
        add_resource_type(solr_hash) if attached_file?
      end
    end

    private
      def add_resource_type(solr_hash)
        if(resource.upload.image.content_type == 'application/pdf')
          solr_hash[:type_tesim] = ['Pdf']
        else
          solr_hash[:type_tesim] = ['Image']
        end
      end
  end
end