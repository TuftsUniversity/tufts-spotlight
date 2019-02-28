namespace :tufts do
  desc 'Fixes bad IIIF urls in Tufts::TdlResources'
  task fix_tdl_resources: :environment do
    ActiveRecord::Base.logger.level = 1
    Tufts::HostnameFixer.fix_all_tdl_resources
  end

  desc 'Updates iiif urls in feature and about pages to a new host.'
  task fix_page_iiif_references: :environment do
    ActiveRecord::Base.logger.level = 1
    Tufts::HostnameFixer.fix_all_page_references
  end
end
