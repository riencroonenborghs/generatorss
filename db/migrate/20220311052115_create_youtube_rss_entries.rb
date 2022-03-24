class CreateYoutubeRssEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :youtube_rss_entries do |t|
      t.references :youtube_channel, null: false, foreign_key: true
      t.datetime :published_at, null: false
      t.string :entry_id, null: false
      t.json :data, null: false

      t.timestamps
    end
  end
end
