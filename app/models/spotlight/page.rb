require File.expand_path('../../app/models/spotlight/page', Spotlight::Engine.called_from)

module Spotlight
  class Page
    scope :in_sidebar, -> { where(in_sidebar: true) }
  end
end
