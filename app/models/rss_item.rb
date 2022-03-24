class RssItem < ApplicationRecord
  MAX_ITEMS_IN_FEED = 25

  belongs_to :itemable, polymorphic: true

  validates :title, :link, :published_at, :guid, presence: true

  def media?
    media_url.present?
  end

  def enclosure?
    enclosure_url.present?
  end

  def itunes?
    return false unless itunes_duration

    !itunes_duration.zero?
  end
end
