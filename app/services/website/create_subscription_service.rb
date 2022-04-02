class Website::CreateSubscriptionService < CreateSubscriptionService
  def initialize(user:, url:)
    super(user: user, input: url, subscriptable_class: Website)
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

    @data = loader.data
    errors.add(:base, "URL has no data") unless data
  end

  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/CyclomaticComplexity
  def parse_url_data
    document = Nokogiri::HTML.parse(data)

    @name = document.css("title")&.children&.first&.to_s
    errors.add(:base, "no name found") and return unless name

    precomposed = document.css("link[rel='apple-touch-icon-precomposed']").first
    non_precomposed = document.css("link[rel='apple-touch-icon']").first
    if precomposed || non_precomposed
      @image_url = (precomposed || non_precomposed)&.attributes["href"]&.value # rubocop:disable Lint/SafeNavigationChain
    end

    feeds_service = ::Website::FindRssFeedsService.call(url: input)
    errors.merge!(feeds_service.errors) and return unless feeds_service.success?

    @rss_url = feeds_service.rss_feeds&.first&.href
    errors.add(:base, "no RSS URL found") and return unless rss_url
  end
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/CyclomaticComplexity

  def find_subscriptable
    @subscriptable = Website.find_by(rss_url: rss_url)
  end

  def build_subscriptable
    @subscriptable = Website.new(rss_url: rss_url, url: input, name: name, image_url: image_url)
  end
end
