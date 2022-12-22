class AddSubreddit < ActiveRecord::Migration[7.0]
  def change
    create_table :subreddits do |t|
      t.datetime :last_loaded
      t.string :url, null: false
      t.string :name, null: false

      t.timestamps
    end

    add_index :subreddits, :last_loaded
  end
end
