namespace :tufts do
  desc 'Fixes bad IIIF urls in Tufts::TdlResources'
  task fix_tdl_resources: :environment do
    ActiveRecord::Base.logger.level = 1
    Tufts::HostnameFixer.fix_all_tdl_resources
  end


  desc 'Updates iiif urls in feature and about pages to a new host.'
  task fix_page_iiif_references: :environment do
    unless(File.file?(ftr_file))
      puts "\nERROR: No json file of SolrDocument -> Resource ids."
      exit
    end
    solr_map = JSON.parse(File.read(ftr_file))
    count = 0

    Spotlight::Page.all.each do |page|
      puts "=============== Processing #{page.id} ================="

      blocks = JSON.parse(page.content.to_s)
      blocks['data'].each do |block|
        next if(fpir_ignore_blocks.include?(block['type']))

        if(fpir_no_items?(block))
          puts "No items: #{block['data']['item']}"
          next
        end

        block['data']['item'].each do |_, item|
          if(!item['full_image_url'].nil? &&  !item['full_image_url'].empty?)
            puts "#{item['full_image_url']} is an upload."
            next
          end
          count = count + 1
          tdl_resource = solr_map[item['id']]

          byebug
#          item['iiif_tilesource'][old_host]  = new_host
#          item['iiif_manifest_url'][old_host]  = new_host
#          item['iiif_canvas_id'][old_host]  = new_host
        end

        break if count >= 11
      end
      #page.content = blocks.to_json
      #page.save
    end
  end

  ##
  # File that contains the old SolrDocument mappings.
  def ftr_file
    "#{Rails.root}/tmp/fix_iiif.json"
  end
end
