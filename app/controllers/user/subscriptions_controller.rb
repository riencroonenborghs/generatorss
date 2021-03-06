class User::SubscriptionsController < User::BaseController
  def index
    @subscriptions = current_user.subscriptions.includes(subscriptable: :twitter_user).order(created_at: :asc).page(params[:page])
    @subscription_count = @subscriptions.total_count
  end

  def create # rubocop:disable Metrics/PerceivedComplexity
    if params.key?(:twitter)
      create_twitter_subscription
    elsif params.key?(:youtube_channel)
      create_youtube_channel_subscription
    elsif params.key?(:website)
      create_website_subscription
    elsif params.key?(:discord_channel)
      create_discord_subscription
    elsif params.key?(:itunes_podcast)
      create_itunes_podcast_subscription
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

  def create_discord_subscription
    @url = params.require(:discord_channel).permit(:url)[:url]
    channel_id = @url.split("/").last
    @service = Discord::CreateSubscriptionService.call(
      user: current_user,
      channel_id: channel_id
    )
  end

  def create_itunes_podcast_subscription
    @url = params.require(:itunes_podcast).permit(:url)[:url]
    @service = Itunes::Podcast::CreateSubscriptionService.call(
      user: current_user,
      url: @url
    )
  end
end
