class Discord::CreateSubscriptionService < CreateSubscriptionService
  def initialize(user:, channel_id:)
    super(user: user, input: channel_id, subscriptable_class: DiscordChannel)
  end

  private

  attr_reader :channel

  def process_input
    service = Discord::Api::ChannelService.new(channel_id: input)
    @channel = service.details
    errors.merge!(service.errors) and return unless service.success?
    errors.add(:base, "cannot find channel details") unless channel
  end

  def find_subscriptable
    @subscriptable = DiscordChannel.find_by(channel_id: input)
  end

  def build_subscriptable
    @subscriptable = DiscordChannel.new(channel_id: input, guild_id: channel.guild_id, name: channel.name, description: channel.topic)
  end
end
