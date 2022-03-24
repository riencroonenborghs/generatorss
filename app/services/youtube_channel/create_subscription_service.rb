class YoutubeChannel::CreateSubscriptionService < CreateSubscriptionService
  def initialize(user:, url:)
    super(user: user, input: url, subscriptable_class: YoutubeChannel)
  end

  private

  attr_reader :rss_url, :name, :image_url

  def process_input
    service = YoutubeChannel::LoadChannelDetailsService.call(url: input)
    errors.merge!(service.errors) and return unless service.success?

    @rss_url = service.rss_url
    @name = service.name
    @image_url = service.image_url
  end

  def find_subscriptable
    @subscriptable = YoutubeChannel.find_by(rss_url: rss_url)
  end

  def build_subscriptable
    @subscriptable = YoutubeChannel.new(rss_url: rss_url, url: input, name: name, image_url: image_url)
  end
end
