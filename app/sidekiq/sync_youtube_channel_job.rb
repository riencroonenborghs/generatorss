class SyncYoutubeChannelJob
  include Sidekiq::Job
  sidekiq_options queue: "generatorss"

  def perform(id)
    youtube_channel = YoutubeChannel.where(id: id).first
    return unless youtube_channel

    YoutubeChannel::CreateRssItemsService.call(youtube_channel: youtube_channel)
  end
end
