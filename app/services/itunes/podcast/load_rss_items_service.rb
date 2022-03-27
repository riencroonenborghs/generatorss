class Itunes::Podcast::LoadRssItemsService < ::LoadRssItemsService
  def rss_header
    {
      "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd"
    }
  end
end
