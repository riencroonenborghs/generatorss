class Twitter::LoadRssItemsService
  include AppService

  attr_reader :channel

  def initialize(twitter_user:, user:)
    @twitter_user = twitter_user
    @user = user
  end

  def rss_header
    {}
  end

  def call
    create_scope
    filter_scope

    @rss_items = @rss_items
                 .order(published_at: :desc)
                 .limit(RssItem::MAX_ITEMS_IN_FEED)

    build_channel
  end

  private

  attr_reader :user, :twitter_user, :rss_items

  def create_scope
    @rss_items = twitter_user
                 .rss_items
  end

  def filter_scope
    filters = user.filters
    engine = ::Filters::EngineService.call(filters: filters, scope: rss_items)
    @rss_items = engine.scope
  end

  def build_channel
    @channel = Rss::Channel.new(
      title: twitter_user.name,
      link: twitter_user.twitter_url,
      last_build_date: Date.current,
      ttl: Subscription::TTL,
      items: rss_items
    )
  end
end
