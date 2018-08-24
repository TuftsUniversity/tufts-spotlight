namespace :tufts do
  desc 'Deletes orphan records (records without an exhibit)'
  task delete_orphans: :environment do
    puts "\n----------- Removing Orphans -----------"

    [FedoraResource, Spotlight::Resources::Upload].each do |resource_type|
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

  namespace :migration do
    desc 'Cleans up broken resources before migration, so they don"t mess up the migration.'
    task pre_migrate_cleanup: :environment do

      Rake::Task['tufts:delete_orphans'].invoke

      puts "\n----------- Removing Duplicates -----------"

      FedoraResource.all.each do |r|
        heading = "\n############ #{r.id} ###########"
        errors = []

        next if(pmc_is_bad?(r, errors))
        pmc_check_for_duplicates(r, errors)

        if(errors.count > 0)
          puts heading
          puts errors.join("\n")
        end
      end

      pmc_destroy_bad_resources
    end

    ### Functions are prefixed pmc_ because they're in global scope. ###

    ##
    # Checks if this is a is part of duplicate resources.
    # Duplicates are determined to be the records without a sidecar.
    # @param {FedoraResource} resource
    #   The FedoraResource to check.
    # @param {arr} errors
    #   The errors array to store errors in.
    def pmc_check_for_duplicates(resource, errors)
      resources = FedoraResource.where(exhibit_id: resource.exhibit_id, url: resource.url)

      return if(resources.count == 1)

      # Resources without sidecars are the bad ones.
      errors << "WARNING: Found duplicates."
      duplicates = resources.each_with_object([]) do |r, dupes|
        dupes << r if(r.solr_document_sidecars.empty?)
      end

      # Verify that we have a definitive prime resource and if so, save the dupes for deletion.
      prime_resource = resources - duplicates
      if(prime_resource.count == 1 && !prime_resource.first.solr_document_sidecars.empty?)
        duplicates.each { |d| pmc_bad_resources << d.id unless pmc_bad_resources.include?(d.id) }
        errors << "Prime resource is #{prime_resource.first.id}"
        errors << "Saved Duplicates to delete later"
      else
        errors << "WARNING: Couldn't determine which were duplicates!"
        # puts resources
      end
    end

    ##
    # Check if already in the bad_resources array.
    # @param {FedoraResource} resource
    #   The FedoraResource to check.
    # @param {arr} errors
    #   The errors array to store errors in.
    def pmc_is_bad?(resource, errors)
      if(pmc_bad_resources.include?(resource.id))
        errors << "This is a bad record already."
        true
      else
        false
      end
    end

    ##
    # Does what it says.
    #
    # Oftentimes, generating an array of records and then deleting rows from the db that are already in
    #   the array can lead to issues. So we save each id, then find each, then destroy one at a time.
    def pmc_destroy_bad_resources
      pmc_bad_resources.each do |r|
        puts "\nDestroying: #{r}"
        FedoraResource.find(r).destroy
      end
    end

    ##
    # The array where we store Url/Exhibit Id of all resources being passed through.
    def pmc_bad_resources
      @pmc_bad_resources ||= []
    end
  end
end