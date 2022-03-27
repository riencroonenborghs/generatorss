class AddItunesFieldsToRssItems < ActiveRecord::Migration[7.0]
  def change
    add_column :rss_items, :itunes_title, :string
    add_column :rss_items, :itunes_summary, :string
  end
end
