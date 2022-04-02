xml.instruct!
xml.rss(
  version: "2.0",
  "xmlns:atom" => "http://www.w3.org/2005/Atom",
  "xmlns:content" => "http://purl.org/rss/1.0/modules/content/",
  "xmlns:googleplay" => "http://www.google.com/schemas/play-podcasts/1.0",
  "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd"
) do
  xml.channel do
    xml.tag!("atom:link", href: @subscription.subscriptable.rss_url, rel: "self", title: "MP3 Audio", type: "application/atom+xml")
    xml.title @channel.title
    xml.language "en"
    xml.lastBuildDate @channel.last_build_date
    xml.pubDate @channel.last_build_date
    xml.link @channel.link
    if @subscription.subscriptable.image_url
      xml.image do
        xml.title @channel.title
        xml.url { xml.text! @subscription.subscriptable.image_url }
      end
    end
    xml.tag!("itunes:image", href: @subscription.subscriptable.image_url) if @subscription.subscriptable.image_url
    xml.tag!("itunes:new-feed-url") { xml.text! @subscription.subscriptable.rss_url }

    @channel.items.each do |item|
      xml.item do
        xml.tag!("guid", isPermaLink: false) { xml.text! item.guid }
        xml.title item.title
        if item.description
          xml.description do
            xml.cdata!(item.description)
          end
        end
        xml.pubDate(item.published_at.iso8601)
        xml.link item.link
        if item.description
          xml.tag!("content:encoded") do
            xml.cdata!(item.description)
          end
        end
        xml.enclosure(url: item.enclosure_url, length: item.enclosure_length, type: item.enclosure_type) if item.enclosure?
        xml.itunesTitle item.itunes_title
        xml.itunesAuthor item.itunes_author
        xml.itunesDuration item.itunes_duration
        xml.itunesSummary item.itunes_summary
        xml.itunesSubtitle item.itunes_summary
        xml.itunesExplicit item.itunes_explicit
        xml.itunesEpisodeType item.itunes_episode_type
        xml.itunesImage item.itunes_image
      end
    end
  end
end
