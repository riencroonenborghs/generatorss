class RssItem < ApplicationRecord
  MAX_ITEMS_IN_FEED = 25
  MAX_ITEMS_IN_COMBINED_FEED = 100

  belongs_to :itemable, polymorphic: true

  validates :title, :link, :published_at, :guid, presence: true
  validates :guid, uniqueness: { scope: :itemable_type }

  def media?
    media_url.present?
  end

  def enclosure?
    enclosure_url.present?
  end

  def youtube?
    itemable_type == "YoutubeChannel"
    # xmlns:yt=\"http://www.youtube.com/xml/schemas/2015\"
  end

  def itunes?
    itemable_type == "ItunesPodcast"
  end

  def youtube_video_id
    @youtube_video_id ||= guid.gsub("yt:video:", "")
  end
end
