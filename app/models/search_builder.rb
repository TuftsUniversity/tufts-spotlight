# frozen_string_literal: true
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior

  include Spotlight::AccessControlsEnforcementSearchBuilder
end
