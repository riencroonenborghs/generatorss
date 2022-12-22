class Subreddit::CreateSubscriptionService < CreateSubscriptionService
  def initialize(user:, url:)
    super(user: user, input: url, subscriptable_class: Subreddit)
  end

  private

  attr_reader :data, :name, :image_url, :rss_url

  def process_input
    load_url_data
    return unless success?

    parse_url_data
    return unless success?
  end

  def load_url_data
    loader = LoadUrlDataService.call(url: input)
    errors.merge!(loader.errors) and return unless loader.success?
    errors.add(:base, "URL has no data") and return unless loader.data

    @data = JSON.parse(loader.data)
    errors.add(:base, "URL has no parsed data") unless data
  rescue JSON::ParserError => e
    errors.add(:base, e.message)
  end

  def parse_url_data
    post = data.dig("data", "children").first
    @name = post.dig("data", "subreddit_name_prefixed")
    errors.add(:base, "no name found") and return unless name
  end

  def find_subscriptable
    @subscriptable = Subreddit.find_by(url: input)
  end

  def build_subscriptable
    @subscriptable = Subreddit.new(url: input, name: name)
  end
end
