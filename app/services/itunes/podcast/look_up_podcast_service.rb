class Itunes::Podcast::LookUpPodcastService
  include AppService

  attr_reader :podcast_id, :rss_url, :image_url, :name, :podcast_url

  def initialize(url:)
    @url = url
  end

  def call
    find_podcast_id
    return unless success?

    look_up_podcast
    return unless success?

    find_podcast_details
  end

  private

  attr_reader :url, :data

  def find_podcast_id
    parsed = URI.parse url
    @podcast_id = parsed.path.split("/").last
    errors.add(:base, "cannot find podcast ID") unless podcast_id
  rescue URI::InvalidURIError => e
    errors.add(:base, e.message)
  end

  def look_up_podcast
    loader = LoadUrlDataService.call(url: "https://itunes.apple.com/lookup/#{podcast_id}")
    errors.merge!(loader.errors) and return unless loader.success?

    json_data = loader.data
    errors.add(:base, "URL has no data") unless json_data

    @data = JSON.parse(json_data)
  end

  def find_podcast_details
    result = data["results"].first
    errors.add(:base, "no podcast data") unless result

    @rss_url = result["feedUrl"]
    @image_url = result["artworkUrl100"]
    @name = result["collectionName"]
    @podcast_url = result["collectionViewUrl"]

    errors.add(:base, "no RSS URL found") unless rss_url
    errors.add(:base, "no name found") unless name
    errors.add(:base, "no podcast URL found") unless podcast_url
  end
end
