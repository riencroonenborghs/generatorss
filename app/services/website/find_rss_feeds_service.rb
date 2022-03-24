require "nokogiri"

class Website::FindRssFeedsService
  include AppService

  RssFeed = Struct.new(:href, :title, keyword_init: true)

  attr_reader :url, :rss_feeds

  def initialize(url:)
    @url = url
    @rss_feeds = []
  end

  def call
    if tumblr?
      find_tumblr
    elsif blogger?
      find_blogger
    elsif medium?
      find_medium
    else
      load_url_data
      find_alternate
    end
  end

  private

  attr_reader :data

  def load_url_data
    loader = LoadUrlDataService.call(url: url)
    errors.merge!(loader.errors) and return unless loader.success?

    @data = loader.data
    errors.add(:base, "URL has no data") unless data
  end

  def tumblr?
    url.match?(/tumblr\./)
  end

  def find_tumblr
    href = find_href(url, href: "rss")
    @rss_feeds = [RssFeed.new(href: href)]
  end

  def blogger?
    url.match?(/blogspot\.com/)
  end

  def find_blogger
    href = find_href(url, href: "feeds/posts/default")
    @rss_feeds = [RssFeed.new(href: href)]
  end

  def medium?
    url.match?(/medium\.com/)
  end

  def find_medium
    pre, post = url.split(/medium\.com/)
    href = "#{pre}medium.com/feed#{post}"
    @rss_feeds = [RssFeed.new(href: href)]
  end

  ATOM_XML = "application/atom+xml".freeze
  RSS_XML = "application/rss+xml".freeze

  def find_alternate
    # <link rel="alternate" type="application/rss+xml" title="RSS" href="rss">
    document = Nokogiri::HTML.parse(data)
    rss_alternates = document.css("link[rel='alternate']").select do |alternate|
      type = alternate.attributes["type"]&.value
      [ATOM_XML, RSS_XML].include?(type)
    end
    errors.add(:base, "no RSS URL found") and return unless rss_alternates

    @rss_feeds = if rss_alternates.size == 1
                   [RssFeed.new(href: rss_link(rss_alternates.first))]
                 else
                   rss_alternates.map do |rss_alternate|
                     RssFeed.new(
                       href: rss_link(rss_alternate),
                       title: rss_alternate["title"]
                     )
                   end
                 end
  end

  def rss_link(rss_alternate)
    href = rss_alternate["href"]
    return href if href.include?("http")

    find_href(url, href: href)
  end

  def find_href(url, href:)
    url.ends_with?("/") ? "#{url}#{href}" : "#{url}/#{href}"
  end
end
