# frozen_string_literal: true

require_dependency Spotlight::Engine.root.join('app', 'models', 'concerns', 'spotlight', 'solr_document').to_s

module Spotlight
  # Monkey Patch to fix broken tags caused by https://github.com/projectblacklight/spotlight/issues/1378
  module SolrDocument
    protected

    # @function
    # If a tagging doesn't have a tagger (exhibit), check if it only has one sidecar.
    # - If it only has one sidecar, set the tag's exhibit to match the sidecar's.
    def tags_to_solr
      h = {}

      Spotlight::Exhibit.find_each do |exhibit|
        h[self.class.solr_field_for_tagger(exhibit)] = nil
      end

      taggings.includes(:tag, :tagger).map do |tagging|
        tag_ok = true

        if tagging.tagger.nil?
          if (sidecars.count == 1)
            this_exhibit = Spotlight::Exhibit.find(sidecars.first.exhibit_id)

            Rails.logger.info("Couldn't find tagger for tagging ##{tagging.id}.")
            Rails.logger.info("Setting exhibit to: #{this_exhibit}")

            tagging.tagger = this_exhibit
            tagging.save
          else
            tag_ok = false
            Rails.logger.error("Tag##{tagging} has two sidecars! Figure it out!")
          end
        end

        if tag_ok
          key = self.class.solr_field_for_tagger(tagging.tagger)
          h[key] ||= []
          h[key] << tagging.tag.name
        end

      end
      h
    end
  end
end