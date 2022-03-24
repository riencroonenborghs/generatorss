class YoutubeChannel::CreateRssItemsService < CreateRssItemsService
  def initialize(youtube_channel:)
    super(subscriptable: youtube_channel)
  end
end
