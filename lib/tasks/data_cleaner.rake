namespace :tufts do
  desc 'Deletes uploads that are missing an upload_id.'
  task delete_uploads_with_no_image: :environment do
    puts "\n----------- Removing Uploads with no Image -----------"

    bad_resources = []
    Spotlight::Resources::Upload.all.each do |r|
      if(r.upload_id.nil?)
        puts "WARNING: (#{r.id}) #{r.data['full_title_tesim']} has no Featured Image."
        bad_resources << r.id unless bad_resources.include?(r.id)
      end
    end

    bad_resources.each { |br| Spotlight::Resources::Upload.find(br).destroy }
  end

  desc 'Deletes orphan records (records without an exhibit)'
  task delete_orphans: :environment do
    puts "\n----------- Removing Orphan Resources -----------"

    [Tufts::TdlResource, Spotlight::Resources::Upload].each do |resource_type|
      bad_resources = []
      puts "\nWorking on #{resource_type.to_s}"

      resource_type.all.each do |r|
        if(Spotlight::Exhibit.where(id: r.exhibit_id).empty?)
          puts "WARNING: #{r.id} has no exhibit (#{r.exhibit_id})."
          bad_resources << r.id unless bad_resources.include?(r.id)
        end
      end

      bad_resources.each { |br| resource_type.find(br).destroy }
    end
  end

  desc 'Deletes orphan sidecars (sidecars without a SolrDocument)'
  task delete_orphan_sidecars: :environment do
    puts "\n----------- Removing Orphan Sidecars -----------"

    bad_sidecars = []
    Spotlight::SolrDocumentSidecar.all.each do |s|
      unless tdc_resource_exists?(s.resource_id) || tdc_solr_doc_exists?(s.document_id)
        puts "WARNING: #{s.id} has no document (#{s.document_id}) or resource (#{s.resource_id})."
        bad_sidecars << s.id unless bad_sidecars.include?(s.id)
      end
    end

    puts "Found #{bad_sidecars.count} broken sidecars."
    bad_sidecars.each { |br| Spotlight::SolrDocumentSidecar.find(br).destroy }
  end


  def tdc_resource_exists?(id)
    begin
      Spotlight::Resource.find(id).present?
    rescue ActiveRecord::RecordNotFound
      false
    end
  end

  def tdc_solr_doc_exists?(id)
    begin
      SolrDocument.find(id).present?
    rescue Blacklight::Exceptions::RecordNotFound
      false
    end
  end
end
