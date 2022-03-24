class Twitter::CreateSubscriptionService < CreateSubscriptionService
  def initialize(user:, url_or_handle:)
    super(user: user, input: url_or_handle, subscriptable_class: TwitterUser)
  end

  private

  attr_reader :name, :twitter_api_user

  def process_input
    get_name
    return unless success?

    get_twitter_api_user
    return unless success?
  end

  def get_name
    if input.match?(/twitter\.com/)
      get_name_from_url
    elsif input.starts_with?("@")
      get_name_from_handle
    else
      errors.add(:base, "not a Twitter URL or handle")
    end
  end

  def get_name_from_url
    uri = URI.parse(input)
    @name = uri.path.slice(1..)
    errors.add(:base, "missing name from Twitter URL") unless name.present?
  end

  def get_name_from_handle
    @name = input.slice(1..)
    errors.add(:base, "missing name from Twitter handle") unless name.present?
  end

  def get_twitter_api_user
    service = Twitter::Api::UsersService.new
    @twitter_api_user = service.find_by(username: name)
    errors.merge!(service.errors) and return unless service.success?
    errors.add(:base, "cannot find Twitter API user") and return unless twitter_api_user
  end

  def find_subscriptable
    @subscriptable = TwitterUser.find_by(twitter_id: twitter_api_user.id)
  end

  def build_subscriptable
    @subscriptable = TwitterUser.new(
      twitter_id: twitter_api_user.id,
      name: twitter_api_user.name,
      username: twitter_api_user.username,
      description: twitter_api_user.description,
      profile_image_url: twitter_api_user.profile_image_url,
      url: twitter_api_user.url,
      verified: twitter_api_user.verified
    )
  end
end
