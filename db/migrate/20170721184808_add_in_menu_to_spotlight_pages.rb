class AddInMenuToSpotlightPages < ActiveRecord::Migration[5.1]
  def change
    add_column :spotlight_pages, :in_menu, :boolean, null: false, default: true
  end
end
