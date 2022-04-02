xml.instruct!
xml.feed(
  "xmlns:yt" => "http://www.youtube.com/xml/schemas/2015",
  "xmlns:media" => "http://search.yahoo.com/mrss/",
  xmlns: "http://www.w3.org/2005/Atom"
  ) do
  xml.link(rel: :self, href: @channel.link)
  xml.id "yt:channel:#{@subscription.subscriptable.channel_id}"
  xml.tag!("yt:channelId") {  xml.text! @subscription.subscriptable.channel_id }
  xml.title @channel.title
  xml.link(ref: "alternate", href: "https://www.youtube.com/channel/#{@subscription.subscriptable.channel_id}")
  xml.published @channel.last_build_date

  @channel.items.each do |item|
    xml.entry do
      xml.id { xml.text! item.guid }
      xml.tag!("yt:videoId") { xml.text! item.youtube_video_id }
      xml.tag!("yt:channelId") {  xml.text! @subscription.subscriptable.channel_id }
      xml.title item.title
      xml.link(ref: "alternate", href: item.link) 
      xml.published(item.published_at.iso8601)
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
    end
  end
end
