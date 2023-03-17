# frozen_string_literal: true

class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior

  include Spotlight::AccessControlsEnforcementSearchBuilder

  self.default_processor_chain += [:add_non_iiif_image_field_to_searches]

  # Autocomplete wasn't using the full_image field and messing up stuff.
  # We need to always have thumbs and full images available.
  def add_non_iiif_image_field_to_searches(solr_parameters)
    unless solr_parameters['fl'].include? Spotlight::Engine.config.full_image_field.to_s
      solr_parameters['fl'] << " #{Spotlight::Engine.config.full_image_field}"
    end
    return if solr_parameters['fl'].include? Spotlight::Engine.config.thumbnail_field.to_s

    solr_parameters['fl'] << " #{Spotlight::Engine.config.thumbnail_field}"
  end
  ##
  # @example Adding a new step to the processor chain
  #   self.default_processor_chain += [:add_custom_data_to_query]
  #
  #   def add_custom_data_to_query(solr_parameters)
  #     solr_parameters[:custom] = blacklight_params[:user_value]
  #   end
end
