class Twitter::CreateRssItemsService
  include AppService

  def initialize(twitter_user:)
    @twitter_user = twitter_user
    @last_loaded = twitter_user.last_loaded
  end

  def call
    load_tweets
    return unless success?

    create_new_rss_items
    return unless success?

    twitter_user.update(last_loaded: Time.zone.now)
  end

  private

  attr_reader :twitter_user, :last_loaded, :tweets

  def api_service
    @api_service ||= Twitter::Api::UsersService.new(id: twitter_user.twitter_id)
  end

  def load_tweets
    api_tweets = api_service.tweets(max_results: 50, since: last_loaded)
    errors.merge!(api_service.errors) and return unless api_service.success?

    @tweets = api_tweets.map do |api_tweet|
      RssItem.new(
        title: api_tweet.title,
        link: "https://twitter.com/#{twitter_user.username}/status/#{api_tweet.id}",
        published_at: api_tweet.created_at,
        description: api_tweet.text,
        guid: api_tweet.id
      )
    end
  end

  def create_new_rss_items
    scope = twitter_user.rss_items
    scope = scope.where("published_at > ?", last_loaded) if last_loaded
    existing_guids = scope.select(:guid).pluck(:guid)

    new_guids = tweets.map(&:guid)
    new_guids -= existing_guids
    new_tweets = tweets.select { |x| new_guids.include?(x.guid) }

    RssItem.transaction do
      twitter_user.rss_items.create!(
        new_tweets.map(&:attributes)
      )
    end
  end
end
