class YoutubeChannel < ApplicationRecord
  include LastLoaded

  has_many :subscriptions, as: :subscriptable
  has_many :rss_items, as: :itemable

  validates :url, :name, :rss_url, :image_url, presence: true

  def channel_id
    @channel_id ||= rss_url.match(/channel_id=(.*)/)[1]
  end
end
