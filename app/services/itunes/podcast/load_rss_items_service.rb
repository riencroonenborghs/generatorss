class Itunes::Podcast::LoadRssItemsService < ::LoadRssItemsService
  private

  def channel_title
    "#{subscriptable.name} - Podcast"
  end
end
