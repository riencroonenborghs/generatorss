class YoutubeChannel::LoadChannelDetailsService
  include AppService

  attr_reader :url, :name, :image_url, :rss_url, :channel_id

  def initialize(url:)
    @url = url
  end

  def call
    load_url_data
    return unless success?

    parse_data
    find_rss_url
    return unless success?

    find_name
    return unless success?

    find_image_url
  end

  private

  attr_reader :data, :document

  def load_url_data
    loader = LoadUrlDataService.call(url: url)
    errors.merge!(loader.errors) and return unless loader.success?

    @data = loader.data
    errors.add(:base, "URL has no data") unless data
  end

  def parse_data
    @document = Nokogiri::HTML.parse(data)
  end

  def find_rss_url
    rss_alternate = document.css("link[rel='alternate']").find do |alternate|
      alternate.attributes["type"]&.value == "application/rss+xml"
    end
    errors.add(:base, "no RSS URL found") and return unless rss_alternate

    @rss_url = rss_alternate["href"]
  end

  def find_name
    meta = document.css("meta[property='og:title']").first
    errors.add(:base, "no name found") and return unless meta

    @name = meta["content"]
  end

  def find_image_url
    meta = document.css("meta[property='og:image']").first
    errors.add(:base, "no image URL found") and return unless meta

    @image_url = meta["content"]
  end
end
