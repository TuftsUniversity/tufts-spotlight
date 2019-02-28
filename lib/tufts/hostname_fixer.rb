module Tufts
  ##
  # @class
  # Changes all references from FedoraResources to TdlResources in feature page content.
  class HostnameFixer
    ##
    # Runs fix_tdl_resources on all resources.
    def self.fix_all_tdl_resources
      @solr_map = {}
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
      begin
        resource.url[old_host] = new_host
        puts "New URL: #{resource.url}"
        resource.save
        resource.reindex
        sleep(2)
        fix_sidecars(resource)
      rescue
        puts "#{resource.url} doesn't match #{old_host}"
      end
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
      @solr_map[old_solr_doc_id] = new_solr_doc_id

      puts "Changing #{old_solr_doc_id} to #{new_solr_doc_id} and deleting other Sidecar"
      all_sidecars[0].document_id = new_solr_doc_id
      all_sidecars[0].save
      all_sidecars[1].destroy
    end

    ##
    # Goes through all the feature pages and fixes the iiif references to the new
    # SolrDocuments and new IIIF urls.
    def self.fix_all_page_references
      load_solr_map
      Spotlight::Page.all.each do |page|
        fix_page_references(page)
      end
    end

    ##
    # Goes through all the feature pages and fixes the iiif references to the new
    # SolrDocuments and new IIIF urls.
    def self.fix_page_references(page)
      puts "=============== Processing #{page.id} ================="

      blocks = JSON.parse(page.content.to_s)
      blocks['data'].each do |block|
        next if(ignore_blocks.include?(block['type']))

        if(no_items?(block))
          puts "No items: #{block['data']['item']}"
          next
        end

        block['data']['item'].each do |_, item|
          if(!item['full_image_url'].nil? &&  !item['full_image_url'].empty?)
            puts "#{item['full_image_url']} is an upload."
            next
          end

          if(!item['iiif_tilesource'].present?)
            puts "#{item['id']} has no tilesource - #{item['iiif_tilesource']}"
            next
          end

          if(item['iiif_tilesource'].include?(old_host))
            fix_item(item, old_host)
          elsif(item['iiif_tilesource'].include?(other_host))
            fix_item(item, other_host)
          else
            puts "#{item['id']}'s tilesource doesn't match  - #{item['iiif_tilesource']}"
            next
          end
        end
      end
      page.content = blocks.to_json
      page.save
    end

    private

      ##
      # Fix page item
      #
      # @param {hash} item
      def self.fix_item(item, old_url)
        begin
          puts "Fixing #{item['id']} - #{item['iiif_tilesource']}"
          new_solr_id = @solr_map[item['id']]
          item['id'] = new_solr_id
          item['iiif_tilesource'][old_url]  = new_host
          item['iiif_manifest_url'][old_url]  = new_host
          item['iiif_canvas_id'][old_url]  = new_host
        rescue StandardError
          byebug
        end
      end

      ##
      # Write solr_map to a tmp file.
      def self.save_solr_map
        f = File.open(solr_map_file, 'w+')
        f.write(@solr_map.to_json)
        f.close
      end

      ##
      # Read the solr_map file into a hash.
      def self.load_solr_map
        @solr_map = JSON.parse(File.read(solr_map_file))
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

      ##
      # Another old hostname.
      def self.other_host
        'dl1.tufts.edu'
      end
  end
end
