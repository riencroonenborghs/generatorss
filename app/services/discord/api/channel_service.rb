class Discord::Api::ChannelService
  include AppService

  def initialize(channel_id:, client: nil)
    @client = client || Discord::Api::Client.new
    @channel_id = channel_id
  end

  def details
    url = "/channels/#{channel_id}"
    data = client.get(url)
    if client.failure?
      errors.merge!(client.errors)
      return nil
    end

    Discord::Api::Channel.build_from(data)
  end

  def messages
    url = "/channels/#{channel_id}/messages"
    data = client.get(url) || []
    if client.failure?
      errors.merge!(client.errors)
      return []
    end

    data.map do |json|
      Discord::Api::Message.build_from(json)
    end
  end

  private

  attr_reader :client, :channel_id
end
