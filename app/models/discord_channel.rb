class DiscordChannel < ApplicationRecord
  include LastLoaded

  has_many :subscriptions, as: :subscriptable
  has_many :rss_items, as: :itemable, dependent: :destroy

  validates :channel_id, :guild_id, :name, presence: true

  def url
    "https://discord.com/channels/#{guild_id}/#{channel_id}"
  end
end
