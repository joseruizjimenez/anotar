class AddVisitsToSessionCredentials < ActiveRecord::Migration
  def change
    add_column :session_credentials, :visits, :integer, :default => 0
  end
end
