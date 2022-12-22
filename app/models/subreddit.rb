class Subreddit < ApplicationRecord
  include LastLoaded

  has_many :subscriptions, as: :subscriptable
  has_many :rss_items, as: :itemable, dependent: :destroy

  validates :url, :name, presence: true
end
