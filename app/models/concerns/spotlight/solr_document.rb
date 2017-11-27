# frozen_string_literal: true

require_dependency Spotlight::Engine.root.join('app', 'models', 'concerns', 'spotlight', 'solr_document').to_s

module Spotlight
  ##
  # Monkey Patch to fix broken tags caused by https://github.com/projectblacklight/spotlight/issues/1378
  module SolrDocument
    protected

    # @function
    # If a tagging doesn't have a tagger (exhibit), check if it only has one sidecar.
    # - If it only has one sidecar, set the tag's exhibit to match the sidecar's.
    # - If it has multiple sidecars, set it to a master_exhibit, if data seems to be consistent.
    def tags_to_solr
      h = {}

      Spotlight::Exhibit.find_each do |exhibit|
        h[self.class.solr_field_for_tagger(exhibit)] = nil
      end

      taggings.includes(:tag, :tagger).map do |tagging|
        if tagging.tagger.nil?
          if (sidecars.count == 1)
            this_exhibit = Spotlight::Exhibit.find(sidecars.first.exhibit_id)

            Rails.logger.info("Couldn't find tagger for tagging ##{tagging.id}.")
            Rails.logger.info("Setting exhibit to: #{this_exhibit}")

            tagging.tagger = this_exhibit
            tagging.save
          else
            if @data_consistent
              tagging.tagger = @master_exhibit
              tagging.save
            else
              Rails.logger.error("Could not infer exhibit for tag ##{tagging}!!")
            end
          end
        end
        key = self.class.solr_field_for_tagger(tagging.tagger)
        h[key] ||= []
        h[key] << tagging.tag.name

        check_exhibit_id_consistency(tagging.tagger)
      end
      h
    end

    private

    # @function
    # Initializes @data_consistent to true, once the first tag in the batch has been saved correctly.
    def data_is_probably_consistent
      # If @data_consistent is set to false, don't change it. Just change nil.
      @data_consistent = true if @data_consistent.nil?
    end

    # @function
    # Data is consistent as long as all tags are being set to the same exhibit.
    # Also initializes @master_exhibit to the first tag's exhibit.
    def check_exhibit_id_consistency(exhibit)
      byebug
      if @master_exhibit.nil?
        @master_exhibit = exhibit
        data_is_probably_consistent
      elsif @master_exhibit == exhibit
        data_is_probably_consistent
      else
        Rails.logger.error("Exhibit mismatch. #{exhibit} does not match #{@master_exhibit}")
        @data_consistent = false
      end
    end
  end
end