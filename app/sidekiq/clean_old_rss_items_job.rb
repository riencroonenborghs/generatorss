class CleanOldRssItemsJob
  include Sidekiq::Job
  sidekiq_options queue: "generatorss"

  def perform
    RssItem
      .where("published_at <= ?", Subscription::RETENTION.days.ago)
      .in_batches(of: 200)
      .destroy_all
  end
end
