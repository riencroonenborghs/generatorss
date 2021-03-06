Discord::Api::Message = Struct.new(:id, :content, :embeds, :timestamp, keyword_init: true) do
  def self.build_from(json)
    message = new(
      id: json["id"],
      content: json["content"],
      embeds: (json["embeds"] || []).map do |embed_json|
        Discord::Api::MessageEmbed.build_from(embed_json)
      end,
      timestamp: Time.zone.parse(json["timestamp"])
    )
    process(message)
  end

  def self.process(message)
    message.embeds.each do |embed|
      next unless embed.link?

      message.content = message.content.gsub(embed.url, "<a href='#{embed.url}' target='_blank'>#{embed.title}</a>")
    end

    message
  end

  def as_rss_item
    link = embeds.any? ? embeds.last.url : "http://foo.bar.baz"
    title = ActionController::Base.helpers.strip_tags content.split(/\n/)[0]

    RssItem.new(
      title: title,
      link: link,
      published_at: timestamp,
      description: content.split("\n").map { |x| "<p>#{x}</p>" }.join,
      guid: id
    )
  end
end
