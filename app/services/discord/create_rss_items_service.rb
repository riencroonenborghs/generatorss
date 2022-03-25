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
    scope = subscriptable.rss_items
    existing_guids = scope.select(:guid).pluck(:guid)

    new_ids = new_entries.map(&:guid)
    new_ids -= existing_guids
    new_entries.select { |x| new_ids.include?(x.guid) }
  end
end
