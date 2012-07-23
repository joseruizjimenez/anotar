class CreateNotes < ActiveRecord::Migration
  def change
    create_table(:notes) do |t|
      t.string :author_id, :null => false, :default => ""
      t.string :text
      t.string :title

      t.timestamps
    end
  end
end
