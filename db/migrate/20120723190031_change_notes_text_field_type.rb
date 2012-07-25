class ChangeNotesTextFieldType < ActiveRecord::Migration
  def up
    remove_column :notes, :text
    add_column :notes, :text, :text
  end

  def down
    change_column :notes, :text, :string
  end
end
