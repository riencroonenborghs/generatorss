class YoutubeChannel::LoadRssItemsService < ::LoadRssItemsService
  def rss_header
    {
      "xmlns:yt" => "http://www.youtube.com/xml/schemas/2015"
    }
  end
end
