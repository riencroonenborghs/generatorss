class CreateRssItems < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_items do |t|
      t.references :itemable, polymorphic: true, null: false
      t.string :title, null: false
      t.string :link, null: false
      t.datetime :published_at, null: false
      t.text :description
      t.string :guid, null: false
      t.string :media_title
      t.string :media_url
      t.string :media_type
      t.integer :media_width
      t.integer :media_height
      t.string :media_thumbnail_url
      t.integer :media_thumbnail_width
      t.integer :media_thumbnail_height

      t.timestamps
    end
  end
end
