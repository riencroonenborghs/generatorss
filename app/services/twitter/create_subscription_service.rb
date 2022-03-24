class Twitter::CreateSubscriptionService
  include AppService

  attr_reader :subscription

  def initialize(user:, url_or_handle:)
    @user = user
    @url_or_handle = url_or_handle
  end

  def call
    extract_name
    return unless success?

    find_twitter_user
    return unless success?

    Subscription.transaction do
      find_or_create_twitter_user
      return unless success?

      subscription_exists?
      return unless success?

      @subscription = user.subscriptions.build(subscriptable: twitter_user)

      if subscription.save
        SyncTwitterUserJob.perform_async(twitter_user.id) if twitter_user.should_load_tweets?
      else
        errors.merge!(subscription.errors)
      end
    end
  end

  private

  attr_reader :user, :url_or_handle, :name, :twitter_user

  def extract_name
    if url_or_handle.match?(/twitter\.com/)
      extract_name_from_url
    elsif url_or_handle.starts_with?("@")
      extract_name_from_handle
    else
      errors.add(:base, "not a Twitter URL or handle")
    end
  end

  def extract_name_from_url
    uri = URI.parse(url_or_handle)
    @name = uri.path.slice(1..)
    errors.add(:base, "missing name from Twitter URL") unless name.present?
  end

  def extract_name_from_handle
    @name = url_or_handle.slice(1..)
    errors.add(:base, "missing name from Twitter handle") unless name.present?
  end

  def find_twitter_user
    service = Twitter::Api::UsersService.new
    twitter_api_user = service.find_by(username: name)
    errors.merge!(service.errors) and return unless service.success?
    errors.add(:base, "cannot find Twitter API user") and return unless twitter_api_user

    twitter_id = twitter_api_user.id

    return if (@twitter_user = TwitterUser.find_by(twitter_id: twitter_id))

    @twitter_user = TwitterUser.new(
      twitter_id: twitter_api_user.id,
      name: twitter_api_user.name,
      username: twitter_api_user.username,
      description: twitter_api_user.description,
      profile_image_url: twitter_api_user.profile_image_url,
      url: twitter_api_user.url,
      verified: twitter_api_user.verified
    )
  end

  def subscription_exists?
    errors.add(:base, "subscription already exists") if user.subscriptions
                                                            .exists?(
                                                              subscriptable_type: "TwitterUser",
                                                              subscriptable_id: twitter_user.id
                                                            )
  end

  def find_or_create_twitter_user
    return if TwitterUser.find_by(twitter_id: twitter_user.twitter_id)

    errors.merge!(twitter_user.errors) unless twitter_user.save
  end
end
