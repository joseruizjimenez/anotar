class AddIndexToSessionCredentials < ActiveRecord::Migration
  def change
    add_index :session_credentials, :session_id, :unique => true
  end
end
