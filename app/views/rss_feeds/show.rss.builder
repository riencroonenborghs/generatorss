xml.instruct!
xml.rss({:version => "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom"}.update(@service.rss_header)) do
  xml.channel do
    xml.title @channel.title
    xml.link @channel.link
    xml.language "en"
    xml.lastBuildDate @channel.last_build_date
    xml.docs "https://validator.w3.org/feed/docs/rss2.html"
    xml.ttl @channel.ttl
    xml.tag! "atom:link", rel: "self", type: "application/rss+xml", href: rss_feed_url(@subscription.uuid, format: :rss)

    @channel.items.each do |item|
      xml.item do
        xml.title item.title
        xml.link item.link
        xml.pubDate(item.published_at.iso8601)
        xml.guid item.guid
        if item.description
          xml.description do
            xml.cdata!(item.description)
          end
        end
        if item.media?
          xml.tag!("media:group") do
            xml.tag!("media:title") { xml.text! item.media_title }
            xml.tag!("media:content", url: item.media_url, type: item.media_type, width: item.media_width, height: item.media_height)
            xml.tag!("media:thumbnail", url: item.media_thumbnail_url, width: item.media_thumbnail_width, height: item.media_thumbnail_height)
          end
        end
        xml.enclosure(url: item.enclosure_url, length: item.enclosure_length, type: item.enclosure_type) if item.enclosure?
        if item.itunes?
          xml.itunesDuration item.itunes_duration
          xml.itunesEpisodeType item.itunes_episode_type
          xml.itunesAuthor item.itunes_author
          xml.itunesExplicit item.itunes_explicit
          xml.itunesImage item.itunes_image
          xml.itunesTitle item.itunes_title
          xml.itunesSummary item.itunes_summary
        end
      end
    end
  end
end
