class ItunesPodcast < ApplicationRecord
  include LastLoaded

  has_many :subscriptions, as: :subscriptable
  has_many :rss_items, as: :itemable, dependent: :destroy

  validates :podcast_id, :url, :rss_url, :name, presence: true
end
