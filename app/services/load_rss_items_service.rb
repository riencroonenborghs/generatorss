class LoadRssItemsService
  include AppService

  attr_reader :channel

  def initialize(subscriptable:, user:)
    @subscriptable = subscriptable
    @user = user
  end

  def call
    create_scope
    filter_scope

    @rss_items = @rss_items
                 .order(published_at: :desc)
                 .limit(RssItem::MAX_ITEMS_IN_FEED)

    build_channel
  end

  def rss_items_tag
    @rss_items_tag ||= @subscriptable.class == YoutubeChannel ? :entry : :item
  end
    

  private

  attr_reader :user, :subscriptable, :rss_items

  def create_scope
    @rss_items = subscriptable
                 .rss_items
  end

  def filter_scope
    filters = user.filters
    engine = ::Filters::EngineService.call(filters: filters, scope: rss_items)
    @rss_items = engine.scope
  end

  def channel_title
    subscriptable.name
  end

  def build_channel
    @channel = Rss::Channel.new(
      title: channel_title,
      link: subscriptable.url,
      last_build_date: Date.current,
      ttl: Subscription::TTL,
      items: rss_items
    )
  end
end
