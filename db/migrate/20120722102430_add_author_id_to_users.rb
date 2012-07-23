class AddAuthorIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :author_id, :string, :null => false, :default => ""
    add_index :users, :author_id, :unique => true
  end
end
