class Subscription < ApplicationRecord
  TTL = 30
  RETENTION = 30

  include Uuid

  belongs_to :user
  belongs_to :subscriptable, polymorphic: true

  scope :twitter_user, -> { where(subscriptable_type: "TwitterUser") }
  scope :youtube_channel, -> { where(subscriptable_type: "YoutubeChannel") }
end
