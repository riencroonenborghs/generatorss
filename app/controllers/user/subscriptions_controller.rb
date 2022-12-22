class User::SubscriptionsController < User::BaseController
  def index
    @subscriptions = current_user.subscriptions.includes(subscriptable: :twitter_user).order(created_at: :asc).page(params[:page])
    @subscription_count = @subscriptions.total_count
  end

  def create
    set_url
    set_service

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

  def set_url
    @url = params.permit(:url)[:url]
  end

  def set_service
    if @url.match?(/twitter\.com/)
      create_twitter_subscription
    elsif @url.match?(/youtube|youtu\.be/)
      create_youtube_channel_subscription
    elsif @url.match?(/discord/)
      create_discord_subscription
    elsif @url.match?(/podcasts/)
      create_itunes_podcast_subscription
    elsif @url.match?(/reddit\.com/)
      create_subreddit_subscription
    else
      create_website_subscription
    end
  end

  def create_twitter_subscription
    @service = Twitter::CreateSubscriptionService.call(
      user: current_user,
      url_or_handle: @url
    )
  end

  def create_youtube_channel_subscription
    @service = YoutubeChannel::CreateSubscriptionService.call(
      user: current_user,
      url: @url
    )
  end

  def create_website_subscription
    @service = Website::CreateSubscriptionService.call(
      user: current_user,
      url: @url
    )
  end

  def create_discord_subscription
    channel_id = @url.split("/").last
    @service = Discord::CreateSubscriptionService.call(
      user: current_user,
      channel_id: channel_id
    )
  end

  def create_itunes_podcast_subscription
    @service = Itunes::Podcast::CreateSubscriptionService.call(
      user: current_user,
      url: @url
    )
  end

  def create_subreddit_subscription
    @service = Subreddit::CreateSubscriptionService.call(
      user: current_user,
      url: @url
    )
  end
end
