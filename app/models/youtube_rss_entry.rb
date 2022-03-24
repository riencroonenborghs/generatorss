class YoutubeRssEntry < ApplicationRecord
  belongs_to :youtube_channel

  validates :data, :published_at, :entry_id, presence: true

  def method_missing(method) # rubocop:disable Style/MissingRespondToMissing
    data[method.to_s]
  end
end
