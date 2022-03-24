class SyncTwitterUserJob
  include Sidekiq::Job
  sidekiq_options queue: "generatorss"

  def perform(id)
    twitter_user = TwitterUser.where(id: id).first
    return unless twitter_user

    Twitter::CreateRssItemsService.call(twitter_user: twitter_user)
  end
end
