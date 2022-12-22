class SyncSubredditJob
  include Sidekiq::Job
  sidekiq_options queue: "generatorss"

  def perform(id)
    subreddit = Subreddit.where(id: id).first
    return unless subreddit

    Subreddit::CreateRssItemsService.call(subreddit: subreddit)
  end
end
