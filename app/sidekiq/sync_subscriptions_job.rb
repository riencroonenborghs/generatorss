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
      else
        SyncDiscordChannelJob.perform_async(id)
      end
    end
  end
end
