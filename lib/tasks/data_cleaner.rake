namespace :tufts do
  desc 'Deletes orphan records (records without an exhibit)'
  task delete_orphans: :environment do
    puts "\n----------- Removing Orphans -----------"

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
end
