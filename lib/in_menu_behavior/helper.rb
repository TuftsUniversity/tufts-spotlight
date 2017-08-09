#@file
# View helpers for in_menu behavior

module InMenuBehavior
  module Helper
    def self.menu_filter(pages)
      pages.published.at_top_level.in_menu
    end

    def self.options(f)
      "<div>#{f.check_box(:in_menu)}</div"
    end
  end
end

