class Twitter::CreateRssItemsService < CreateRssItemsService
  def initialize(twitter_user:)
    super(subscriptable: twitter_user)
  end

  private

  def load_new_entries
    api_service = Twitter::Api::UsersService.new(id: subscriptable.twitter_id)
    api_tweets = api_service.tweets(max_results: 50, since: last_loaded)
    errors.merge!(api_service.errors) and return unless api_service.success?

    @new_entries = api_tweets.map do |api_tweet|
      RssItem.new(
        title: api_tweet.title,
        link: "https://twitter.com/#{subscriptable.username}/status/#{api_tweet.id}",
        published_at: api_tweet.created_at,
        description: api_tweet.text,
        guid: api_tweet.id
      )
    end
  end

  def entries_to_add
    scope = subscriptable.rss_items
    scope = scope.where("published_at > ?", last_loaded) if last_loaded
    existing_guids = scope.select(:guid).pluck(:guid)

    new_guids = new_entries.map(&:guid)
    new_guids -= existing_guids
    new_entries.select { |x| new_guids.include?(x.guid) }
  end
end
