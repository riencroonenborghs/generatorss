class Website::CreateRssItemsService < CreateRssItemsService
  def initialize(website:)
    super(subscriptable: website)
  end

  private

  attr_reader :data

  def load_new_entries
    load_url_data
    return unless success?

    parse_url_data
    return unless success?
  end

  def entries_to_add
    new_guids = new_entries.map(&:entry_id)
    existing_guids = subscriptable.rss_items.where(guid: new_guids).distinct.pluck(:guid)
    new_guids -= existing_guids
    new_entries.select { |x| new_guids.include?(x.entry_id) }
  end

  def load_url_data
    loader = LoadUrlDataService.call(url: subscriptable.rss_url)
    errors.merge!(loader.errors) and return unless loader.success?

    @data = loader.data
    errors.add(:base, "URL has no data") unless data
  end

  def parse_url_data
    parsed_data = Feedjira.parse(data)
    errors.add(:base, "could not parse RSS data") and return unless parsed_data
    errors.add(:base, "no RSS entries found") and return unless parsed_data.entries

    @new_entries = parsed_data.entries
  rescue StandardError => e
    errors.add(:base, e.message)
  end
end
