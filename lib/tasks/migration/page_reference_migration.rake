namespace :tufts do
  namespace :migration do
    desc 'Update references in pages from FedoraResources to TdlResources'
    task migrate_page_references_to_iiif: [ :environment ] do
      # i = 0
      # max = 100

      Spotlight::Page.all.each do |page|
        # break if(i >= max)
        Tufts::PageReferenceMigrator.migrate_references(page)
        # i += 1
      end
    end
  end
end