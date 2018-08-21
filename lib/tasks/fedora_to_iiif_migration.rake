namespace :tufts do
  desc 'Run the FedoraResource to TdlResource migration'
  task migrate_to_tdl: :environment do
    all_fedora_resources = FedoraResource.all
    # i = 0
    # max = 100

    FedoraResource.all.each do |record|
      # break if(i >= max)
      Tufts::TdlMigrator.migrate_record(record)
      # i += 1
    end
  end
end