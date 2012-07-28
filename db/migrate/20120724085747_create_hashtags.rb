class CreateHashtags < ActiveRecord::Migration
  def change
    create_table(:hashtags) do |t|
      t.string :name, :null => false, :default => ""
      t.integer :hits, :default => 1

      t.timestamps
    end
  end
end
