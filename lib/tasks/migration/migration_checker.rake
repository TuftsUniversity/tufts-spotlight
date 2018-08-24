namespace :tufts do
  namespace :migration do
    desc 'Run the FedoraResource to TdlResource migration'
    task check_migration: :environment do

      if(Tufts::TdlResource.count > FedoraResource.count)
        puts "WARNING: Somehow, there's more TdlResources than FedoraResources."
      end

      FedoraResource.all.each do |fed_r|
        errors = []
        headings = [ "\n############### #{fed_r.id} ##################" ]

        # Check the migration table for the matching TdlResource
        migration_data = tcm_migration_data.search_by_fed_id(fed_r.id)
        if(migration_data.empty?)
          puts headings.first
          puts "WARNING: Not in migration table."
          next
        end

        # Attempt to load the matching TdlResource.
        begin
          tdl_r = Tufts::TdlResource.find(migration_data[:tdl_id])
        rescue ActiveRecord::RecordNotFound
          puts headings.first
          puts "WARNING: Couldn't find TdlResource #{migration_data[:tdl_id]}."
          next
        end
        headings << "INFO: TdrResource id: #{tdl_r.id}"

        # Do our checks.
        tcm_check_sidecars(fed_r, tdl_r, errors)
        tcm_check_docs(fed_r, tdl_r, errors)

        # Print stuff out, if we have errors.
        if(errors.count > 0)
          puts headings.join("\n")
          puts errors.join("\n")
        end
      end
    end # end task
  end # end namespace

  ## prefix methods with tcm (tufts migration checker), because they're in global scope ##

  ##
  # Tests that the exhibit-specific data and public settings match across migration.
  # Can't test tags because they literally move from source to destination objects.
  #
  # @param {FedoraResource} fed_r
  #   The FedoraResource obj.
  # @param {Tufts::TdlResource} tdl_r
  #   The TdlResource obj.
  # @params {arr} errors
  #   The overarching error array for this entire process.
  def tcm_check_sidecars(fed_r, tdl_r, errors)
    fed_s = fed_r.sidecar
    tdl_s = tdl_r.sidecar

    errors << "WARNING: public/private mismatch." unless(tdl_s.public? == fed_s.public?)
    errors << "WARNING: data mismatch" unless(tdl_s.data == fed_s.data)
  end

  ##
  # Attempts to load the two SolrDocuments, catching errors if necessary.
  # Checks the metadata of the docs via tcm_check_metadata if loading is successful.
  #
  # @param {FedoraResource} fed_r
  #   The FedoraResource obj.
  # @param {Tufts::TdlResource} tdl_r
  #   The TdlResource obj.
  # @params {arr} errors
  #   The overarching error array for this entire process.
  def tcm_check_docs(fed_r, tdl_r, errors)
    docs_ok = true

    begin
      fed_d = fed_r.solr_doc
    rescue StandardError
      docs_ok = false
      errors << "WARNING: Couldn't load SolrDoc for FedoraResource."
    end

    begin
      tdl_d = tdl_r.solr_doc
    rescue StandardError
      docs_ok = false
      errors << "WARNING: Couldn't load SolrDoc for TdlResource."
    end

    tcm_check_metadata(fed_d, tdl_d, errors) if(docs_ok)
  end

  ##
  # Compares the metadata in the solr_documents of the two records.
  # @param {SolrDocument} fed_d
  #   The FedoraResource SolrDocument
  # @param {SolrDocument} tdl_d
  #   The TdlResource SolrDocument
  # @params {arr} errors
  #   The overarching error array for this entire process.
  def tcm_check_metadata(fed_d, tdl_d, errors)
    tcm_solr_fields.each do |f|
      if(fed_d[f].nil? != tdl_d[f].nil?)
        errors << "WARNING: #{f} is in one SolrDocument and not the other."
        next
      end

      next if(fed_d[f].nil?)

      if(tcm_standardize(fed_d[f]) != tcm_standardize(tdl_d[f]))
        errors << "WARNING: #{f} in the SolrDocuments don't match."
      end
    end
  end

  ##
  # Standardizes the metadata arrays by sorting the values and downcasing the text.
  #
  # @param {arr} value
  #   The metadata value from a SolrDocument.
  def tcm_standardize(value)
    value.sort.map { |v| v.downcase }
  end

  ##
  # The descriptive metadata fields.
  # rights_tesim and date_tesim may be changed by the Fedora migration, so we can't really test those.
  # date_created will no longer exist.
  def tcm_solr_fields
    [
      "full_title_tesim",
      "creator_tesim",
      "description_tesim",
      "publisher_tesim",
      "subject_tesim",
      "type_tesim",
      "format_tesim",
      "permanent_url_tesim",
      "area_of_interest_tesim",
      "corporation_tesim",
      "citation_tesim"
    ]
  end

  ##
  # The database connection to the migration table data.
  def tcm_migration_data
    @tcm_migration_data ||= Tufts::MigrationData.new
  end
end