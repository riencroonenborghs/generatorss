class Twitter::LoadRssItemsService < LoadRssItemsService
  def channel_title
    "@#{subscriptable.username}"
  end
end
