xml.instruct!
xml.rss(version: "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom") do
  xml.channel do
    xml.title @channel.title
    xml.link @channel.link
    xml.language "en"
    xml.lastBuildDate @channel.last_build_date
    xml.docs "https://validator.w3.org/feed/docs/rss2.html"
    xml.ttl @channel.ttl
    xml.tag! "atom:link", rel: "self", type: "application/rss+xml", href: rss_feed_url(@subscription.uuid, format: :rss)

    @channel.items.each do |item|
      xml.tag!(@service.rss_items_tag) do
        xml.title item.title
        xml.link item.link
        xml.pubDate(item.published_at.iso8601)
        xml.guid item.guid
        if item.description
          xml.description do
            xml.cdata!(item.description)
          end
        end
      end
    end
  end
end
