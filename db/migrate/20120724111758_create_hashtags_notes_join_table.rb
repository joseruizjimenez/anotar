class CreateHashtagsNotesJoinTable < ActiveRecord::Migration
  def change
    create_table :hashtags_notes, :id => false do |t|
      t.integer :hashtag_id
      t.integer :note_id
    end
    add_index :hashtags_notes, :hashtag_id
    add_index :hashtags_notes, :note_id
  end
end
