class CreateWebsites < ActiveRecord::Migration[7.0]
  def change
    create_table :websites do |t|
      t.datetime :last_loaded
      t.string :url
      t.string :rss_url
      t.string :name
      t.string :image_url

      t.timestamps
    end
    
    add_index :websites, :rss_url
  end
end
