require 'rsolr'

module Tufts
  ##
  # @class
  # Migrates FedoraResource objects into TdlResource objects.
  class TdlMigrator

    ##
    # Migrates a single record.
    # @param {FedoraResource} record
    #   The FedoraResource object to change into TdlResource.
    def self.migrate_record(record)
      if(record.exhibit_id.nil? || !record.has_exhibit?)
        puts "No exhibit (#{record.exhibit_id}) for item #{record.id}: #{record.url}"
        return false
      end

      new_id = get_new_id(record.url)
      unless(new_id)
        puts "Couldn't find a record with the legacy pid: #{record.url}."
        return false
      end

      manifest_url = "#{tufts_settings[:tdl_url]}#{new_id}/manifest.json"
      new_resource = TdlResource.new({url: manifest_url, exhibit_id: record.exhibit_id})
      new_resource.save
      Spotlight::ReindexJob.perform_now(new_resource)
      sleep(1)

      exhibit_name = Spotlight::Exhibit.find(new_resource.exhibit_id).title
      puts "Migrating FedoraResource: #{record.id} to TdlResource #{new_resource.id} in #{exhibit_name}"

      merge_sidecars(record, new_resource)

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
      # Merges the old record's sidecar data into the new record's sidecar data.
      # @param {FedoraResource} old_r
      #   The old, FedoraResource.
      # @param {TdlResource} new_r
      #   The new, TdlResource.
      def self.merge_sidecars(old_r, new_r)
        if(old_r.sidecar.nil?)
          puts "INFO: FedoraResource: #{old_r.id} has no sidecars."
          return
        end

        # Sometimes sidecars won't change.
        needs_update = false

        old_sidecar = old_r.sidecar
        new_sidecar = new_r.solr_document_sidecars.first

        # If the old sidecar has exhibit-specific data, copy it to the new one.
        if(old_sidecar.data.empty? || old_sidecar.data.nil?)
          puts "INFO: FedoraResource: #{old_r.id} has no data in its sidecar."
        else
          new_sidecar.data.merge!(old_sidecar.data)
          needs_update = true
        end

        # If the old sidecar has public set to false, set the new car to false as well.
        if(old_sidecar.public == false)
          new_sidecar.public = false
          needs_update = true
        end

        new_sidecar.save if(needs_update)
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
  end
end