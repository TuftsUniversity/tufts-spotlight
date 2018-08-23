namespace :tufts do
  namespace :migration do
    desc 'Run the FedoraResource to TdlResource migration'
    task migrate_to_tdl: :environment do
      # i = 0
      # max = 100

      # Set up the migration data table. Either create it or clear it.
      data_table = Tufts::MigrationData.new
      data_table.create_table
      data_table.clear_table

      FedoraResource.all.each do |resource|
        # break if(i >= max)
        Tufts::TdlMigrator.migrate_resource(resource)
        # i += 1
      end
    end
  end
end