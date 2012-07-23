class CreateSessionCredentials < ActiveRecord::Migration
  def change
    create_table(:session_credentials) do |t|
      t.string :author_id, :null => false, :default => ""
      t.string :session_id, :null => false, :default => ""

      t.timestamps
    end
    add_index :session_credentials, :author_id, :unique => true
  end
end
