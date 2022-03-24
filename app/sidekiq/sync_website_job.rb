class SyncWebsiteJob
  include Sidekiq::Job
  sidekiq_options queue: "generatorss"

  def perform(id)
    website = Website.where(id: id).first
    return unless website

    Website::CreateRssItemsService.call(website: website)
  end
end
