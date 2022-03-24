class CreateRssItemsService
  include AppService

  def initialize(subscriptable:)
    @subscriptable = subscriptable
    @last_loaded = subscriptable.last_loaded
  end

  def call
    load_url_data
    return unless success?

    load_rss_entries
    return unless success?

    create_new_rss_items
    return unless success?

    subscriptable.update(last_loaded: Time.zone.now)
  end

  private

  attr_reader :data, :entries, :subscriptable, :last_loaded, :tweets

  def load_url_data
    loader = LoadUrlDataService.call(url: subscriptable.rss_url)
    errors.merge!(loader.errors) and return unless loader.success?

    @data = loader.data
    errors.add(:base, "URL has no data") unless data
  end

  def load_rss_entries
    parsed_data = Feedjira.parse(data)
    errors.add(:base, "could not parse RSS data") and return unless parsed_data
    errors.add(:base, "no RSS entries found") and return unless parsed_data.entries

    @entries = parsed_data.entries
  end

  def create_new_rss_items
    new_guids = entries.map(&:entry_id)
    existing_guids = subscriptable.rss_items.where(guid: new_guids).pluck(:guid)

    new_guids -= existing_guids
    new_entries = entries.select { |x| new_guids.include?(x.entry_id) }

    RssItem.transaction do
      subscriptable.rss_items.create!(
        new_entries.map do |entry|
          hash = {
            title: entry.title,
            link: entry.url,
            published_at: entry.published,
            description: entry.content,
            guid: entry.entry_id
          }
          %i[media_title media_url media_type media_width media_height media_thumbnail_url media_thumbnail_width media_thumbnail_height enclosure_length enclosure_type enclosure_url itunes_duration itunes_episode_type itunes_author itunes_explicit itunes_image].each do |media|
            hash[media] = entry.send(media) if entry.respond_to?(media)
          end
          hash
        end
      )
    end
  end
end
