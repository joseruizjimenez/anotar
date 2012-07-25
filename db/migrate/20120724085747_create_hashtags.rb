class CreateHashtags < ActiveRecord::Migration
  def change
    create_table(:hashtags) do |t|
      t.string :name, :null => false, :default => ""
      t.integer :hits, :default => 0

      t.timestamps
    end
  end
end
