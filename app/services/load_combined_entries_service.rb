class LoadCombinedEntriesService
  include AppService

  attr_reader :channel

  def initialize(subscriptions:, user:)
    @subscriptions = subscriptions
    @user = user
  end

  def call
    create_scope
    filter_scope

    @rss_items = @rss_items
                 .order(published_at: :desc)
                 .limit(RssItem::MAX_ITEMS_IN_COMBINED_FEED)

    build_channel
  end

  private

  attr_reader :user, :rss_items

  def create_scope
    scope = RssItem.includes(itemable: %i[twitter_user youtube_channel website])
    twitter_user_scope = scope
                         .where(
                           itemable_type: "TwitterUser",
                           itemable_id: itemables_for("TwitterUser")
                         )
    youtube_channel_scope = scope
                            .where(
                              itemable_type: "YoutubeChannel",
                              itemable_id: itemables_for("YoutubeChannel")
                            )
    website_scope = scope
                    .where(
                      itemable_type: "Website",
                      itemable_id: itemables_for("Website")
                    )
    
    discord_channel_scope = scope
                            .where(
                              itemable_type: "DiscordChannel",
                              itemable_id: itemables_for("DiscordChannel")
                            )

    itunes_podcast_scope = scope
                           .where(
                             itemable_type: "ItunesPodcast",
                             itemable_id: itemables_for("ItunesPodcast")
                           )

    @rss_items = twitter_user_scope
                 .or(youtube_channel_scope)
                 .or(website_scope)
                 .or(discord_channel_scope)
                 .or(itunes_podcast_scope)
  end

  def itemables_for(itemable_type)
    user.subscriptions
        .order(created_at: :asc)
        .where(subscriptable_type: itemable_type)
        .select(:subscriptable_id)
  end

  def filter_scope
    filters = user.filters
    engine = ::Filters::EngineService.call(filters: filters, scope: rss_items)
    @rss_items = engine.scope
  end

  def build_channel
    @channel = Rss::Channel.new(
      title: "Combined feed",
      last_build_date: Date.current,
      ttl: Subscription::TTL,
      items: rss_items
    )
  end
end
