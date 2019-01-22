class RemoveIndexFromUsersEmail < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, :column => :email
  end
end
