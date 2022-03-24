class YoutubeChannel::CreateSubscriptionService
  include AppService

  attr_reader :subscription

  def initialize(user:, url:)
    @user = user
    @url = url
  end

  def call
    load_channel_details
    return unless success?

    Subscription.transaction do
      find_or_create_youtube_channel
      return unless success?

      subscription_exists?
      return unless success?

      @subscription = user.subscriptions.build(subscriptable: youtube_channel)

      if subscription.save
        SyncYoutubeChannelJob.perform_async(youtube_channel.id) if youtube_channel.should_load_tweets?
      else
        errors.merge!(subscription.errors)
      end
    end
  end

  private

  attr_reader :user, :url, :rss_url, :name, :image_url, :youtube_channel

  def load_channel_details
    service = YoutubeChannel::LoadChannelDetailsService.call(url: url)
    errors.merge!(service.errors) and return unless service.success?

    @rss_url = service.rss_url
    @name = service.name
    @image_url = service.image_url
  end

  def subscription_exists?
    errors.add(:base, "subscription already exists") if user.subscriptions
                                                            .exists?(
                                                              subscriptable_type: "YoutubeChannel",
                                                              subscriptable_id: youtube_channel.id
                                                            )
  end

  def find_or_create_youtube_channel
    return if (@youtube_channel = YoutubeChannel.find_by(rss_url: rss_url))

    @youtube_channel = YoutubeChannel.new(rss_url: rss_url, url: url, name: name, image_url: image_url)
    errors.merge!(youtube_channel.errors) unless youtube_channel.save
  end
end
