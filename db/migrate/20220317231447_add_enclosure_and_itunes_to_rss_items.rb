class AddEnclosureAndItunesToRssItems < ActiveRecord::Migration[7.0]
  def change
    { enclosure_length: :integer, enclosure_type: :string, enclosure_url: :string,
      itunes_duration: :integer, itunes_episode_type: :string, itunes_author: :string,
      itunes_explicit: :boolean, itunes_image: :string }.each do |name, type|
      add_column :rss_items, name, type
    end
  end
end
