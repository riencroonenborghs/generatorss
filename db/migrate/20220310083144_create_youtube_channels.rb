class CreateYoutubeChannels < ActiveRecord::Migration[7.0]
  def change
    create_table :youtube_channels do |t|
      t.datetime :last_loaded
      t.string :url, null: false
      t.string :rss_url, null: false
      t.string :name, null: false
      t.string :image_url, null: false

      t.timestamps
    end

    add_index :youtube_channels, :rss_url
  end
end
