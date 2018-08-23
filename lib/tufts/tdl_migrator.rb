require 'rsolr'

module Tufts
  ##
  # @class
  # Migrates FedoraResource objects into TdlResource objects.
  class TdlMigrator

    ##
    # Migrates a single resource.
    # @param {FedoraResource} old_resource
    #   The FedoraResource object to change into TdlResource.
    def self.migrate_resource(old_resource)
      if(old_resource.exhibit_id.nil? || !old_resource.has_exhibit?)
        puts "No exhibit (#{old_resource.exhibit_id}) for item #{old_resource.id}: #{old_resource.url}"
        return false
      end

      new_id = get_new_id(old_resource.url)
      unless(new_id)
        puts "Couldn't find a resource with the legacy pid: #{old_resource.url}."
        return false
      end

      manifest_url = "#{tufts_settings[:tdl_url]}#{new_id}/manifest.json"
      new_resource = TdlResource.new({url: manifest_url, exhibit_id: old_resource.exhibit_id})
      new_resource.save
      Spotlight::ReindexJob.perform_now(new_resource)
      sleep(1)

      exhibit_name = Spotlight::Exhibit.find(new_resource.exhibit_id).title
      puts "\nMigrating FedoraResource: #{old_resource.id} to TdlResource #{new_resource.id} in #{exhibit_name}"

      merge_sidecars(old_resource, new_resource)
      save_migration_data(old_resource, new_resource)

      return new_resource
    end

    private

      ##
      # Queries TDL Solr to get new Fedora 4 id, using legacy pid.
      # @param {str} old_id
      #   The old Fedora 3 pid.
      def self.get_new_id(old_id)
        response = solr.get('select', params: { q: "legacy_pid_tesim:#{old_id}"})
        docs = response['response']['docs']
        return false if(docs.empty?)

        docs.first["id"]
      end

      ##
      # Merges the old resource's sidecar data into the new resource's sidecar data.
      # @param {FedoraResource} old_r
      #   The old, FedoraResource.
      # @param {TdlResource} new_r
      #   The new, TdlResource.
      def self.merge_sidecars(old_r, new_r)
        if(old_r.sidecar.nil?)
          puts "INFO: FedoraResource: #{old_r.id} has no sidecars."
          return
        end

        # Some sidecars have nothing in them. No need for a database call.
        needs_update = false

        old_sidecar = old_r.sidecar
        new_sidecar = new_r.sidecar

        # If the old sidecar has exhibit-specific data, copy it to the new one.
        if(old_sidecar.data.empty? || old_sidecar.data.nil?)
          puts "INFO: FedoraResource: #{old_r.id} has no data in its sidecar."
        else
          puts "INFO: Merging FedoraResource: #{old_r.id} sidecar data with #{new_r.id} sidecar. "
          new_sidecar.data.merge!(old_sidecar.data)
          needs_update = true
        end

        # If the old sidecar has public set to false, set the new car to false as well.
        unless(old_sidecar.public?)
          puts "INFO: FedoraResource: #{old_r.id} is not public. Changing TdlResource: #{new_r.id}."
          new_sidecar.public = false # Not using the private! method because that saves immediately.
          needs_update = true
        end

        unless(old_sidecar.taggings.empty?)
          puts "INFO: Merging FedoraResource: #{old_r.id} tags into TdlResource: #{new_r.id} sidecar."
          new_sidecar.tags = old_sidecar.tags
          new_sidecar.taggings = old_sidecar.taggings
          needs_update = true
        end

        if(needs_update)
          new_sidecar.save
          Spotlight::ReindexJob.perform_now(new_r)
          sleep(1)
        end
      end

      ##
      # Saves the FedoraResource, TdlResource and both SolrDocument ids to the migration table.
      # Need to map back and forth when migrating the item references in page content.
      def self.save_migration_data(old_r, new_r)
        migration_data.add_row(new_r.id, new_r.doc_id, old_r.id, old_r.doc_id)
      end

      ##
      # Our solr connection.
      def self.solr
        @solr_instance ||= ::RSolr.connect(url: tufts_settings[:migrator_solr])
      end

      ##
      # Settings from tufts.yml in config.
      def self.tufts_settings
        @tufts_settings ||= Tufts::Settings.load
      end

      ##
      # Class that saves migration-specific data to the database.
      def self.migration_data
        @migration_data ||= Tufts::MigrationData.new
      end
  end
end