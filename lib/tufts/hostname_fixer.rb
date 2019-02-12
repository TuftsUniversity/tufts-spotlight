module Tufts
  ##
  # @class
  # Changes all references from FedoraResources to TdlResources in feature page content.
  class HostnameFixer
    ##
    # Runs fix_tdl_resources on all resources.
    def self.fix_all_tdl_resources
      Tufts::TdlResource.all.each { |r| fix_tdl_resource(r) }
      save_solr_map
    end

    ##
    # Changes the url property of a Tufts::TdlResource, and it's sidecar.
    #
    # @param #{Tufts::TdlResource} resource
    #   The resource to fix.
    def self.fix_tdl_resource(resource)
      puts "\n\n--------------- Fixing #{resource.id} ---------------"
      puts "Old URL: #{resource.url}"
      resource.url[old_host] = new_host
      puts "New URL: #{resource.url}"
      resource.save
      resource.reindex
      sleep(2)
      fix_sidecars(resource)
    end

    ##
    # Changing the url of a TdlResource creates a new SolrDocument and
    # SolrDocumentSidecar. The old SolrDocument can be deleted, but there's data in the
    # sidecar that must be preserved.
    #
    # @param #{Tufts::TdlResource} resource
    #   The resource to fix.
    def self.fix_sidecars(resource)
      puts "\n------- Fixing Sidecar -------"
      all_sidecars = resource.solr_document_sidecars
        .where(exhibit_id: resource.exhibit_id)
        .sort_by(&:created_at)

      if(all_sidecars.count != 2)
        puts "#{resource.id} has #{all_sidecars.count} sidecars!"
        return
      end

      old_solr_doc_id = all_sidecars[0].document_id
      new_solr_doc_id = all_sidecars[1].document_id
      solr_map[resource.id] = {
        old_solr: old_solr_doc_id,
        new_solr: new_solr_doc_id
      }

      puts "Changing #{old_solr_doc_id} to #{new_solr_doc_id} and deleting other Sidecar"
      all_sidecars[0].document_id = new_solr_doc_id
      all_sidecars[0].save
      all_sidecars[1].destroy
    end

    ##
    # Goes through all the feature pages and fixes the iiif references to the new
    # SolrDocuments and new IIIF urls.
    def self.fix_page_references
    end

    private
      ##
      # The mappings of solr documents.
      def self.solr_map
        @solr_map ||= []
      end

      ##
      # Write solr_map to a tmp file.
      def self.save_solr_map
        f = File.open(solr_map_file, 'w+')
        f.write(solr_map.to_json)
        f.close
      end

      ##
      # Read the solr_map file into a hash.
      def self.open_solr_map
        JSON.parse(File.read(solr_map_file))
      end

      ##
      # Map file location.
      def self.solr_map_file
        "#{Rails.root}/tmp/fix_iiif.json"
      end

      ##
      # SirTrevorBlock has no items?
      # @param {json} block
      #   The data of a single Sir Trevor Block
      def self.no_items?(block)
        block['data'].nil? || block['data'].empty? || block['data']['item'].nil? || block['data']['item'].empty?
      end

      # Blocks that don't have images.
      def self.ignore_blocks
        [
          "text",
          "heading",
          "rule",
          "quote",
          "featured_pages",
          "iframe",
          "list",
          "browse"
        ]
      end

      ##
      # The old hostname.
      def self.old_host
        'tdl-prod-01.uit.tufts.edu'
      end

      ##
      # The old hostname.
      def self.new_host
        'dl.tufts.edu'
      end
  end
end
