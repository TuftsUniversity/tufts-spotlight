class ChangeDataTypeForContent < ActiveRecord::Migration[5.1]
  def self.up
    change_column :spotlight_pages, :content, :text, limit: 16.megabytes - 1
  end

  def self.down
    change_column :spotlight_pages, :content, :text, limit: 64.kilobytes - 1
  end
end
