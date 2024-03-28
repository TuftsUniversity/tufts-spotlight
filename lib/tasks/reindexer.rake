# frozen_string_literal: true

namespace :tufts do
  desc 'Reindexes the entire site in a way that fails gracefully'
  task reindex: :environment do
    puts "\n----------- Starting Full Reindex -----------"
    [Tufts::TdlResource, Spotlight::Resources::Upload].each do |resource_type|
      puts "\n== Working on #{resource_type} =="
      puts

      resource_type.all.find_each do |r|
        all_ok = true

        if Spotlight::Exhibit.where(id: r.exhibit_id).empty?
          puts "WARNING: #{r.id} has no exhibit (#{r.exhibit_id})."
          all_ok = false
        elsif resource_type == Spotlight::Resources::Upload && r.upload_id.nil?
          puts "WARNING: (#{r.id}) #{r.data['full_title_tesim']} has no Featured Image."
          all_ok = false
        end

        next unless all_ok

        puts "Reindexing: #{r.id}"
        begin
          r.reindex
        rescue JSON::ParserError => e
          puts "\n"
          puts e.message
          e.backtrace.each { |line| puts line }
          puts "\n"
        end
      end
    end
  end
end
