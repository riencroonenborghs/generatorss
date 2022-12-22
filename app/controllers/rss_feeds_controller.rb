class RssFeedsController < ApplicationController
  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/CyclomaticComplexity
  def show
    @subscription = Subscription.includes(:user)
                                .includes(subscriptable: %i[twitter_user youtube_channel website discord_channel subreddit])
                                .find_by(uuid: params[:uuid])
    redirect_to root_path and return unless @subscription

    user = @subscription.user
    redirect_to root_path and return unless user.subscriptions
                                                .order(created_at: :asc)
                                                .pluck(:id)
                                                .include?(@subscription.id)

    @service = case @subscription.subscriptable
               when TwitterUser
                 Twitter::LoadRssItemsService.call(
                   subscriptable: @subscription.subscriptable,
                   user: @subscription.user
                 )
               when YoutubeChannel
                 YoutubeChannel::LoadRssItemsService.call(
                   subscriptable: @subscription.subscriptable,
                   user: @subscription.user
                 )
               when Website
                 Website::LoadRssItemsService.call(
                   subscriptable: @subscription.subscriptable,
                   user: @subscription.user
                 )
               when DiscordChannel
                 Discord::LoadRssItemsService.call(
                   subscriptable: @subscription.subscriptable,
                   user: @subscription.user
                 )
               when ItunesPodcast
                 Itunes::Podcast::LoadRssItemsService.call(
                   subscriptable: @subscription.subscriptable,
                   user: @subscription.user
                 )
               when Subreddit
                 Subreddit::LoadRssItemsService.call(
                   subscriptable: @subscription.subscriptable,
                   user: @subscription.user
                 )
               else
                 redirect_to root_path and return
               end
    @channel = @service.channel

    respond_to do |format|
      case @subscription.subscriptable
      when TwitterUser
        format.rss { render "twitter_user" }
      when YoutubeChannel
        format.rss { render "youtube_channel" }
      when Website
        format.rss { render "website" }
      when DiscordChannel
        format.rss { render "discord_channel" }
      when ItunesPodcast
        format.rss { render "itunes_podcast" }
      when Subreddit
        format.rss { render "subreddit" }
      end
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/CyclomaticComplexity

  def combined
    @user = User.includes(subscriptions: { subscriptable: %i[twitter_user youtube_channel discord_channel] }).find_by(uuid: params[:uuid])
    redirect_to root_path and return unless @user

    service = LoadCombinedEntriesService.call(
      subscriptions: @user.subscriptions,
      user: @user
    )
    @channel = service.channel

    respond_to do |format|
      format.rss
    end
  end
end
