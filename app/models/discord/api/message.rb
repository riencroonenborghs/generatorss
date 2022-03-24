class Discord::Api::Message < Struct.new(:id, :content, :embeds, :timestamp, keyword_init: true)
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
    link = embeds.any? ? embeds.first.url : "http://foo.bar.baz"

    {
      title: content,
      link: link,
      published_at: timestamp,
      guid: id
    }
  end
end
