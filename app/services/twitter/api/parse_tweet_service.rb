class Twitter::Api::ParseTweetService
  attr_reader :data, :tweet

  def initialize(data:)
    @data = data
  end

  def call
    build_body

    @tweet = Twitter::Api::Tweet.new(
      id: data["id"],
      title: title,
      created_at: Time.parse(data["created_at"]).in_time_zone,
      text: body
    )
  end

  private

  attr_reader :body

  def text
    @text ||= data["text"]
  end

  def text_truncated?
    text.size > 100
  end

  def title
    text_truncated? ? "#{text.first(100)}..." : text
  end

  def build_body
    @body = data["text"]

    replace_mentions!
    replace_urls!
  end

  def replace_mentions!
    (data.dig("entities", "mentions") || []).each do |mention|
      username = "@#{mention['username']}"
      url = "https://twitter.com/#{mention['id']}"
      @body = body.gsub(username, build_link(url, username, username))
    end
  end

  def replace_urls!
    (data.dig("entities", "urls") || []).each do |url|
      short_url = url["url"]
      expanded_url = url["expanded_url"]
      title = url["title"]
      @body = body.gsub(short_url, build_link(expanded_url, title, expanded_url))
    end
  end

  def build_link(url, label, title)
    "<a href='#{url}' title='#{title}' target='_blank'>#{label}</a>"
  end
end
