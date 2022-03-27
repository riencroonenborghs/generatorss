class Discord::CreateRssItemsService < CreateRssItemsService
  def initialize(discord_channel:)
    super(subscriptable: discord_channel)
  end

  private

  def load_new_entries
    service = Discord::Api::ChannelService.new(channel_id: subscriptable.channel_id)
    @new_entries = service.messages.map(&:as_rss_item)
    errors.merge!(service.errors) and return unless service.success?
  end

  def entries_to_add
    new_guids = new_entries.map(&:guid)
    existing_guids = subscriptable.rss_items.where(guid: new_guids).distinct.pluck(:guid)
    new_guids -= existing_guids
    new_entries.select { |x| new_guids.include?(x.guid) }
  end
end
