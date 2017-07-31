require_dependency Spotlight::Engine.root.join('app', 'models', 'spotlight', 'page').to_s

module Spotlight
  class Page < ActiveRecord::Base
    scope :in_menu, -> { where(in_menu: true) }
  end
end
