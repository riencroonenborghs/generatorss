class User::SubscriptionsController < User::BaseController
  def index
    @subscriptions = current_user.subscriptions.includes(subscriptable: :twitter_user).order(created_at: :asc).page(params[:page])
    @subscription_count = @subscriptions.total_count
  end

  def create
    if params.key?(:twitter)
      create_twitter_subscription
    elsif params.key?(:youtube_channel)
      create_youtube_channel_subscription
    elsif params.key?(:website)
      create_website_subscription
    end

    respond_to do |format|
      if @service.success?
        format.html { redirect_to user_subscriptions_path, notice: "Subscription added." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    subscription = current_user.subscriptions.find(params[:id])
    subscription.destroy

    respond_to do |format|
      format.html { redirect_to user_subscriptions_path, notice: "Subscription removed." }
    end
  end

  private

  def create_twitter_subscription
    @url_or_handle = params.require(:twitter).permit(:url_or_handle)[:url_or_handle]
    @service = Twitter::CreateSubscriptionService.call(
      user: current_user,
      url_or_handle: @url_or_handle
    )
  end

  def create_youtube_channel_subscription
    @url = params.require(:youtube_channel).permit(:url)[:url]
    @service = YoutubeChannel::CreateSubscriptionService.call(
      user: current_user,
      url: @url
    )
  end

  def create_website_subscription
    @url = params.require(:website).permit(:url)[:url]
    @service = Website::CreateSubscriptionService.call(
      user: current_user,
      url: @url
    )
  end
end
