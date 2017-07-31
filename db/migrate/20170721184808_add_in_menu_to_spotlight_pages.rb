class AddInMenuToSpotlightPages < ActiveRecord::Migration
  def change
    add_column :spotlight_pages, :in_menu, :boolean, null: false, default: true
  end
end
