class AddIndexesOnEverything < ActiveRecord::Migration[7.0]
  def change
    add_index :subscriptions, :subscriptable_type
    add_index :subscriptions, :subscriptable_id
    add_index :subscriptions, [:subscriptable_type, :subscriptable_id]
    add_index :subscriptions, [:user_id, :subscriptable_type, :subscriptable_id], name: "sub_user_full_subscriptable"
    add_index :subscriptions, :uuid

    add_index :twitter_users, :last_loaded

    add_index :youtube_channels, :last_loaded

    add_index :youtube_rss_entries, :published_at
    add_index :youtube_rss_entries, :entry_id

    add_index :rss_items, :itemable_type
    add_index :rss_items, :itemable_id
    add_index :rss_items, [:itemable_type, :itemable_id]
    add_index :rss_items, :published_at

    add_index :filters, [:user_id, :value]

    add_index :websites, :last_loaded
  end
end
