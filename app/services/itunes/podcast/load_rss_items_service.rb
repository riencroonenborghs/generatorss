class Itunes::Podcast::LoadRssItemsService < ::LoadRssItemsService
  def rss_header
    {
      "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd"
    }
  end

  private

  def channel_title
    "#{subscriptable.name} - Podcast"
  end
end
