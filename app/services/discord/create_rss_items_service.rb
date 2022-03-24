class Discord::CreateRssItemsService
  include AppService

  def initialize(discord_channel:)
    @discord_channel = discord_channel
    @last_loaded = discord_channel.last_loaded
  end

  def call
    load_messages
    return unless success?

    create_new_rss_items
    return unless success?

    discord_channel.update(last_loaded: Time.zone.now)
  end

  private

  attr_reader :discord_channel, :last_loaded, :messages

  def load_messages
    service = Discord::Api::ChannelService.new(channel_id: discord_channel.channel_id)
    @messages = service.messages
    errors.merge!(service.errors) and return unless service.success?
  end

  def create_new_rss_items
    scope = discord_channel.rss_items
    scope = scope.where("published_at > ?", last_loaded) if last_loaded
    existing_guids = scope.select(:guid).pluck(:guid)

    new_ids = messages.map(&:id)
    new_ids -= existing_guids
    new_messages = messages.select { |x| new_ids.include?(x.id) }

    RssItem.transaction do
      discord_channel.rss_items.create!(
        new_messages.map(&:as_rss_item)
      )
    end
  end
end
