class YoutubeChannel::LoadRssItemsService < ::LoadRssItemsService
  private

  def channel_title
    "#{subscriptable.name} - Youtube"
  end
end
