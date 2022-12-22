class Subreddit::CreateRssItemsService < CreateRssItemsService
  def initialize(subreddit:)
    super(subscriptable: subreddit)
  end

  private

  attr_reader :data

  def load_new_entries
    load_url_data
    return unless success?

    parse_url_data
    return unless success?
  end

  def load_url_data
    loader = LoadUrlDataService.call(url: subscriptable.url)
    errors.merge!(loader.errors) and return unless loader.success?

    @data = loader.data
    errors.add(:base, "URL has no data") unless data
  end

  def parse_url_data
    @new_entries = JSON.parse(data).dig("data", "children")
  rescue StandardError => e
    errors.add(:base, e.message)
  end

  def entries_to_add
    new_guids = new_entries.map { |entry| entry.dig("data", "id") }
    existing_guids = subscriptable.rss_items.where(guid: new_guids).distinct.pluck(:guid)
    new_guids -= existing_guids
    new_entries.select { |entry| new_guids.include?(entry.dig("data", "id")) }
  end

  def entry_description(entry)
    entry.dig("data", "selftext")
  end

  def entry_title(entry, description)
    entry.dig("data", "title")
  end

  def entry_link(entry)
    entry.dig("data", "url")
  end

  def entry_published_at(entry)
    created_utc = entry.dig("data", "created_utc")
    Time.at(created_utc)
  rescue
    nil
  end

  def entry_guid(entry)
    entry.dig("data", "id")
  end
end
