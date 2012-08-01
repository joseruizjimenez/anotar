class AddEditCountAndPublicToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :edit_count, :integer, :default => 0
    add_column :notes, :shared, :boolean, :default => false
    add_column :notes, :fav, :boolean, :default => false
    add_column :notes, :html_text, :text
  end
end
