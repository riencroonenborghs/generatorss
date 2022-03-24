class TwitterUser < ApplicationRecord
  include LastLoaded

  has_many :subscriptions, as: :subscriptable
  has_many :rss_items, as: :itemable, dependent: :destroy

  validates :twitter_id, :name, :username, presence: true

  def twitter_url
    "https://twitter.com/#{username}"
  end
end
