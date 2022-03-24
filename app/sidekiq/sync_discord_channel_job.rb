class SyncDiscordChannelJob
  include Sidekiq::Job
  sidekiq_options queue: "generatorss"

  def perform(id)
    discord_channel = DiscordChannel.where(id: id).first
    return unless discord_channel

    Discord::CreateRssItemsService.call(discord_channel: discord_channel)
  end
end
