class AddInSidebarToSpotlightPages < ActiveRecord::Migration
  def change
    add_column :spotlight_pages, :in_sidebar, :boolean, null: false, default: true
  end
end
