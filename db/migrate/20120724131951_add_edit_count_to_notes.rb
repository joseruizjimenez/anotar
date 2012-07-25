class AddEditCountToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :edit_count, :integer, :default => 0
  end
end
