require 'open-uri'

module Tufts
  ##
  # @class
  # Changes all references from FedoraResources to TdlResources in feature page content.
  class PageReferenceMigrator
    ##
    # Migrates the page content of a single page.
    #
    # @param {Spotlight::Page} page
    #   The page object with content.
    def self.migrate_references(page)
      puts "=============== #{page.id} ================="

      blocks = JSON.parse(page.content.to_s)
      blocks['data'].each do |block|
        next if(ignore_blocks.include?(block['type']))

        if(no_items?(block))
          puts "No items: #{block['data']['item']}"
          next
        end

        block['data']['item'].each do |_, item|
          if(has_no_image?(item))
            puts "Item has no image: #{item['full_image_url']}"
            next
          end

          if(is_upload?(item))
            puts "Item is an upload: #{item['full_image_url']}"
            next
          end

          puts "Processing item: #{item['id']}:  #{item['full_image_url']}"

          migration_map_results = migration_data.search_by_fed_doc_id(item['id'])
          if(migration_map_results.count == 1)
            new_solr_id = migration_map_results[0][:tdl_solr_id]
          else
            new_solr_id = find_correct_tdl_solr_id(migration_map_results, page.exhibit_id)
          end

          new_doc = SolrDocument.find(new_solr_id)
          manifest = new_doc["iiif_manifest_url_ssi"]
          img_info = new_doc["content_metadata_image_iiif_info_ssm"].first

          manifest_json = JSON.parse(open(manifest).read)
          canvas = manifest_json['sequences'][0]['canvases'][0]['@id']

          item['id'] = new_solr_id
          item['iiif_tilesource'] = img_info
          item['iiif_manifest_url'] = manifest
          item['iiif_canvas_id'] = canvas
          item.delete('thumbnail_image_url')
          item.delete('full_image_url')
        end
      end

      page.content = blocks.to_json
      page.save
    end

    private

      ##
      # The class that draws from the migration table in the db.
      def self.migration_data
        @migration_data ||= Tufts::MigrationData.new
      end

      ##
      # Some SolrDocuments point to two different FedoraResources.
      # This figures out which one we want and returns the requisite TDLResource-based SolrDocument id.
      # @param {array} results
      #   The results from the database call.
      def self.find_correct_tdl_solr_id(results, exhibit_id)
        target = results.detect { |r| FedoraResource.find(r[:fedora_id]).exhibit_id == exhibit_id }
        target[:tdl_solr_id]
      end

      ##
      # Our Tufts::Settings
      def self.tufts_settings
        @tufts_settings ||= Tufts::Settings.load
      end

      ##
      # SirTrevorBlock has no items?
      # @param {json} block
      #   The data of a single Sir Trevor Block
      def self.no_items?(block)
        block['data'].nil? || block['data'].empty? || block['data']['item'].nil? || block['data']['item'].empty?
      end

      ##
      # Item has no image defined?
      # @param {json} item
      #   The specific item in a SirTrevorBlock
      def self.has_no_image?(item)
        item['full_image_url'].nil? || item['full_image_url'].empty?
      end

      ##
      # Item is an upload? - don't migrate Spotlight:Resources::Upload items.
      # @param {json} item
      #   The specific item in a SirTrevorBlock
      def self.is_upload?(item)
        item['full_image_url'][0] == '/'
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
  end
end
