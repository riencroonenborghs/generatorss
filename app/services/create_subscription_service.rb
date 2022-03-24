class CreateSubscriptionService
  include AppService

  attr_reader :subscription

  def initialize(user:, input:, subscriptable_class:)
    @user = user
    @input = input
    @subscriptable_class = subscriptable_class
  end

  def call
    process_input
    return unless success?

    Subscription.transaction do
      find_or_create_subscriptable
      return unless success?

      subscription_exists?
      return unless success?

      @subscription = user.subscriptions.build(subscriptable: subscriptable)

      if subscription.save
        job_class = "Sync#{subscriptable_class.to_s}Job".constantize
        job_class.perform_async(subscriptable.id)
      else
        errors.merge!(subscription.errors)
      end
    end
  end

  private

  attr_reader :user, :input, :subscriptable_class, :subscriptable

  def process_input
  end

  def find_or_create_subscriptable
    return if find_subscriptable

    @subscriptable = build_subscriptable
    errors.merge!(subscriptable.errors) unless subscriptable.save
  end

  def find_subscriptable
  end

  def build_subscriptable
  end

  def subscription_exists?
    return unless user.subscriptions
                      .exists?(
                        subscriptable_type: subscriptable_class.to_s,
                        subscriptable_id: subscriptable.id
                      )

    errors.add(:base, "subscription already exists")
  end  
end
