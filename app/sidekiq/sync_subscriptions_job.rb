class SyncSubscriptionsJob
  include Sidekiq::Job
  sidekiq_options queue: "generatorss"

  def perform
    Subscription.pluck(:subscriptable_type, :subscriptable_id).each do |type, id|
      case type
      when "TwitterUser"
        SyncTwitterUserJob.perform_async(id)
      when "YoutubeChannel"
        SyncYoutubeChannelJob.perform_async(id)
      when "Website"
        SyncWebsiteJob.perform_async(id)
      when "DiscordChannel"
        SyncDiscordChannelJob.perform_async(id)
      when "Subreddit"
        SyncSubredditJob.perform_async(id)
      else
        SyncItunesPodcastJob.perform_async(id)
      end
    end
  end
end
