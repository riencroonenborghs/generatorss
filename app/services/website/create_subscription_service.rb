class Website::CreateSubscriptionService
  include AppService

  attr_reader :subscription

  def initialize(user:, url:)
    @user = user
    @url = url
  end

  def call
    load_url_data
    return unless success?

    load_website_details
    return unless success?

    Subscription.transaction do
      find_or_create_website
      return unless success?

      subscription_exists?
      return unless success?

      @subscription = user.subscriptions.build(subscriptable: website)

      if subscription.save
        SyncWebsiteJob.perform_async(website.id) if website.should_load_tweets?
      else
        errors.merge!(subscription.errors)
      end
    end
  end

  private

  attr_reader :user, :url, :data, :rss_url, :name, :image_url, :website

  def load_website_details
    document = Nokogiri::HTML.parse(data)
    precomposed = document.css("link[rel='apple-touch-icon-precomposed']").first
    non_precomposed = document.css("link[rel='apple-touch-icon']").first

    @name = document.css("title")&.children&.first&.to_s
    @image_url = (precomposed || non_precomposed)&.attributes["href"]&.value # rubocop:disable Lint/SafeNavigationChain

    errors.add(:base, "no name found") and return unless name

    feeds_service = ::Website::FindRssFeedsService.call(url: url)
    errors.merge!(feeds_service.errors) and return unless feeds_service.success?

    @rss_url = feeds_service.rss_feeds.first&.href
    errors.add(:base, "no RSS URL found") and return unless name
  end

  def load_url_data
    loader = LoadUrlDataService.call(url: url)
    errors.merge!(loader.errors) and return unless loader.success?

    @data = loader.data
    errors.add(:base, "URL has no data") unless data
  end

  def subscription_exists?
    errors.add(:base, "subscription already exists") if user.subscriptions
                                                            .exists?(
                                                              subscriptable_type: "Website",
                                                              subscriptable_id: website.id
                                                            )
  end

  def find_or_create_website
    return if (@website = Website.find_by(rss_url: rss_url))

    @website = Website.new(rss_url: rss_url, url: url, name: name, image_url: image_url)
    errors.merge!(website.errors) unless website.save
  end
end
