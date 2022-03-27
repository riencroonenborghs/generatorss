class CreateItunesPodcasts < ActiveRecord::Migration[7.0]
  def change
    create_table :itunes_podcasts do |t|
      t.datetime :last_loaded
      t.string :podcast_id, null: false
      t.string :url, null: false
      t.string :rss_url, null: false
      t.string :name, null: false
      t.string :image_url

      t.timestamps
    end

    add_index :itunes_podcasts, :podcast_id
  end
end
