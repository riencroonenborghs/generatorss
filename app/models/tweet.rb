class Tweet < ApplicationRecord
  belongs_to :twitter_user

  validates :tweet_id, :text, :title, :tweeted_at, presence: true

  scope :most_recent_first, -> { order(tweeted_at: :desc) }
end
