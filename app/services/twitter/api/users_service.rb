class Twitter::Api::UsersService
  include AppService

  attr_reader :id

  def initialize(api_client: Twitter::Api::Client.new, id: nil)
    @api_client = api_client
    @id = id
  end

  def find_by(username:)
    query = {
      "user.fields" => "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld"
    }
    url = "/users/by/username/#{username}"
    data = api_client.parse(
      api_client.get(url, query: query)
    )
    if api_client.failure?
      errors.merge!(api_client.errors)
      return nil
    end

    Twitter::Api::User.new(
      profile_image_url: data["profile_image_url"],
      id: data["id"],
      description: data["description"],
      url: data["url"],
      username: data["username"],
      name: data["name"],
      verified: data["verified"]
    )
  end

  def tweets(max_results: 5, since: nil)
    query = {
      max_results: max_results,
      expansions: "attachments.media_keys,attachments.poll_ids,entities.mentions.username",
      "tweet.fields" => "id,created_at,text,referenced_tweets,attachments,withheld,geo,entities,public_metrics,possibly_sensitive,source,lang,context_annotations,conversation_id,reply_settings",
      "media.fields" => "media_key,duration_ms,height,preview_image_url,type,url,width,promoted_metrics,alt_text",
      "poll.fields" => "id,options,voting_status,end_datetime,duration_minutes"
    }
    query.update(start_time: since.utc.iso8601) if since

    url = "/users/#{id}/tweets"
    data = api_client.parse(
      api_client.get(url, query: query)
    )
    if api_client.failure?
      errors.merge!(api_client.errors)
      return nil
    end

    (data || []).map do |datum|
      builder = Twitter::Api::ParseTweetService.new(data: datum)
      builder.call
      builder.tweet
    end
  end

  private

  attr_reader :api_client
end
