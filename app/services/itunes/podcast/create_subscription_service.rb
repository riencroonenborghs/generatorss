class Itunes::Podcast::CreateSubscriptionService < CreateSubscriptionService
  def initialize(user:, url:)
    super(user: user, input: url, subscriptable_class: ItunesPodcast)
  end

  private

  attr_reader :podcast_id, :rss_url, :image_url, :name, :url

  def process_input
    service = Itunes::Podcast::LookUpPodcastService.call(url: input)
    errors.merge!(service.errors) and return unless service.success?

    @podcast_id = service.podcast_id
    @rss_url = service.rss_url
    @url = service.podcast_url
    @image_url = service.image_url
    @name = service.name
  end

  def find_subscriptable
    @subscriptable = ItunesPodcast.find_by(podcast_id: podcast_id)
  end

  def build_subscriptable
    @subscriptable = ItunesPodcast.new(podcast_id: podcast_id, url: url, rss_url: rss_url, image_url: image_url, name: name)
  end
end
