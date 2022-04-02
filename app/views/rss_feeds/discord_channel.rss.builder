xml.instruct!
xml.rss(version: "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom") do
  xml.channel do
    xml.title "#{@channel.title} - Discord"
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
        xml.description do
          xml.cdata!(item.description)
        end if item.description
        if item.media?
          xml.tag!("media:group") do
            xml.tag!("media:title") { xml.text! item.media_title }
            xml.tag!("media:content", url: item.media_url, type: item.media_type, width: item.media_width, height: item.media_height)
            xml.tag!("media:thumbnail", url: item.media_thumbnail_url, width: item.media_thumbnail_width, height: item.media_thumbnail_height)
            xml.tag!("media:description") do
              xml.cdata!(item.description)
            end
          end
        end
        xml.enclosure(url: item.enclosure_url, length: item.enclosure_length, type: item.enclosure_type) if item.enclosure?
      end
    end
  end
end
