class ChangeModelAttributesToHashAfterRailsUpgrade < ActiveRecord::Migration[5.0]

  ## @params
  # {
  #   Model  => [ { field_info, more_field_info }, { field_info, more_field_info }, { field_info, more_field_info } ],
  #   Model2 => [ { field_info, more_field_info }, { field_info, more_field_info }, { field_info, more_field_info } ]
  # }

  ##
  # @function
  # Removes the need to write this nested loop over and over.
  def apply_to_each_model_and_field
    @params.each do |model, fields|
      fields.each do |f|
        yield model, f
      end
    end
  end

  ##
  # @function
  # Defines the initial model/column names, and programmatically defines our tmp columns and table-name symbols.
  def define_legacy_column_info
    @params = {
      Spotlight::BlacklightConfiguration => [
        { col: "default_solr_params" },
        { col: "facet_fields" },
        { col: "index" },
        { col: "index_fields" },
        { col: "search_fields" },
        { col: "show" },
        { col: "sort_fields" }
      ],
      Spotlight::Contact => [
        { col: "contact_info" }
      ],
      Spotlight::CustomField => [
        { col: "configuration" }
      ],
      Spotlight::Resource => [
        { col: "data" }
      ],
      Spotlight::Search => [
        { col: "query_params" }
      ],
      Spotlight::SolrDocumentSidecar => [
        { col: "data" },
        { col: "index_status" }
      ]
    }

    eliminate_working_models

    apply_to_each_model_and_field do |m,f|
      f[:table] = m.table_name.to_sym
      f[:tmp_col] = "#{f[:col]}_raw"
    end
  end

  ##
  # @function
  # Discovers whether the listed models are actually broken or not
  def eliminate_working_models
    @params.each do |m, fields|
      model_broken = false
      begin
        fields.each { |f| m.pluck(f[:col]) }
      rescue ActiveRecord::SerializationTypeMismatch
        model_broken = true
      end
      @params.delete(m) unless model_broken
    end
  end

  ##
  # @function
  # Creates the tmp column, moves data from normal column into it, and empties the normal column.
  # Must be done for each legacy column before moving forward, or we can't load the record to set the column later.
  def move_legacy_data
    apply_to_each_model_and_field do |m, f|
      add_column f[:table], f[:tmp_col].to_sym, :text
      m.update_all("`#{f[:tmp_col]}` = `#{f[:col]}`")
      m.update_all("`#{f[:col]}` = NULL")
    end
  end

  ##
  # @function
  # Translates the data into a Hash and re-enters it into the normal column.
  def translate_data
    apply_to_each_model_and_field do |m, f|
      m.all.each do |record|
        record[f[:col]] = YAML::load(record[f[:tmp_col]]).to_h unless record[f[:tmp_col]].nil?
        record.save!
      end
    end
  end

  ##
  # @function
  # Removes all the temporary columns.
  def delete_tmp_columns
    apply_to_each_model_and_field do |m,f|
      remove_column f[:table], f[:tmp_col]
    end
  end

  def up
    define_legacy_column_info
    move_legacy_data
    translate_data
    delete_tmp_columns
  end
end
