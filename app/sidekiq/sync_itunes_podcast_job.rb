class SyncItunesPodcastJob
  include Sidekiq::Job
  sidekiq_options queue: "generatorss"

  def perform(id)
    itunes_podcast = ItunesPodcast.where(id: id).first
    return unless itunes_podcast

    Itunes::Podcast::CreateRssItemsService.call(itunes_podcast: itunes_podcast)
  end
end
