require "rails_helper"

RSpec.describe Twitter::Api::UsersService, type: :service do
  let(:api_client) { double }

  before do
    allow(api_client).to receive(:get)
    allow(api_client).to receive(:failure?).and_return(false)
    allow(api_client).to receive(:parse).and_return(response)
  end

  describe "#find_by(username:)" do
    let(:profile_image_url) { "https://pbs.twimg.com/profile_images/812853314870198273/EwlBdugJ_normal.jpg" }
    let(:id) { "17948810" }
    let(:description) { "I am the comedian formerly known as Hugo Boss. UK & Ireland 2022 tour tickets on sale now!" }
    let(:url) { "https://t.co/Cgkbc1whgj" }
    let(:username) { "joelycett" }
    let(:name) { "Joe Lycett" }
    let(:verified) { true }
    let(:response) do
      {
        "description" => description,
        "id" => id,
        "created_at" => "2008-12-07T21:58:37.000Z",
        "pinned_tweet_id" => "1464981847230849024",
        "username" => username,
        "location" => "Birmingham, England",
        "public_metrics" => {
          "followers_count" => 1_055_253,
          "following_count" => 4_112,
          "tweet_count" => 1_027,
          "listed_count" => 1_138
        },
        "url" => url,
        "name" => name,
        "protected" => false,
        "profile_image_url" => profile_image_url,
        "entities" => {
          "url" => {
            "urls" => [
              { "start" => 0, "end" => 23, "url" => "https://t.co/Cgkbc1whgj", "expanded_url" => "http://www.joelycett.com/", "display_url" => "joelycett.com" }
            ]
          }
        },
        "verified" => verified
      }
    end

    subject { described_class.new(api_client: api_client) }

    let(:username) { "joelycett" }

    it "queries the api client for user fields" do
      query = { "user.fields" => "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld" }
      expect(api_client).to receive(:get).with("/users/by/username/#{username}", query: query)
      subject.find_by(username: username)
    end

    it "parses the response" do
      expect(api_client).to receive(:parse).and_return(response)
      subject.find_by(username: username)
    end

    context "when something went wrong" do
      before do
        client = Twitter::Api::Client.new
        client.parse("")
        errors = client.errors

        allow(api_client).to receive(:failure?).and_return(true)
        allow(api_client).to receive(:errors).and_return(errors)
      end

      it "fails" do
        subject.find_by(username: username)
        expect(subject).to_not be_success
      end

      it "sets an error" do
        subject.find_by(username: username)
        expect(subject.errors.full_messages).to include anything
      end

      it "returns nil" do
        expect(subject.find_by(username: username)).to be_nil
      end
    end

    context "when all went good" do
      it "succeeds" do
        subject.find_by(username: username)
        expect(subject).to be_success
      end

      it "returns an API twitter user" do
        expect(subject.find_by(username: username)).to be_a Twitter::Api::User
      end

      context "when there's an API twitter user" do
        let(:twitter_user) { subject.find_by(username: username) }

        it "has a the relevant data" do
          expect(twitter_user.profile_image_url).to eq profile_image_url
          expect(twitter_user.id).to eq id
          expect(twitter_user.description).to eq description
          expect(twitter_user.url).to eq url
          expect(twitter_user.username).to eq username
          expect(twitter_user.name).to eq name
          expect(twitter_user.verified).to eq verified
        end
      end
    end
  end

  describe "#tweets" do
    let(:max_results) { 10 }
    let(:since) { 1.day.ago }
    let(:id) { "123" }
    let(:text) { "Possibly the first time someone has been nominated for a Royal Television Society award because they dressed as an oil company CEO and shat out of their mouth" }
    let(:title) { "Possibly the first time someone has been nominated for a Royal Television Society award because they..." }
    let(:created_at) { "2022-03-04T14:15:22.000Z" }
    let(:response) do
      [
        {
          "lang" => "en",
          "possibly_sensitive" => false,
          "public_metrics" => {
            "retweet_count" => 16,
            "reply_count" => 21,
            "like_count" => 900,
            "quote_count" => 1
          },
          "created_at" => created_at,
          "source" => "Twitter for iPhone",
          "entities" => {
            "urls" => [
              {
                "start" => 159,
                "end" => 182,
                "url" => "https://t.co/kKZI1Gx6HM",
                "expanded_url" => "https://twitter.com/RTS_media/status/1499734655423025157",
                "display_url" => "twitter.com/RTS_media/stat…"
              }
            ],
            "annotations" => [
              {
                "start" => 57,
                "end" => 86,
                "probability" => 0.3056,
                "type" => "Other",
                "normalized_text" => "Royal Television Society award"
              }
            ]
          },
          "reply_settings" => "everyone",
          "id" => id,
          "text" => text,
          "referenced_tweets" => [
            { "type" => "quoted", "id" => "1499734655423025157" }
          ],
          "conversation_id" => "1499750350940688389"
        },
        {
          "lang" => "en",
          "possibly_sensitive" => false,
          "attachments" => { "media_keys" => ["7_1498221523760467970"] },
          "public_metrics" => { "retweet_count" => 1326, "reply_count" => 0, "like_count" => 0, "quote_count" => 0 },
          "created_at" => "2022-02-28T11:07:22.000Z",
          "entities" => {
            "mentions" => [
              { "start" => 3, "end" => 17, "username" => "JoshPughComic", "id" => "251779677" }
            ],
            "urls" => [
              {
                "start" => 40,
                "end" => 63,
                "url" => "https://t.co/N3uTkw6Ysa",
                "expanded_url" => "https://twitter.com/JoshPughComic/status/1498221804552339463/video/1",
                "display_url" => "pic.twitter.com/N3uTkw6Ysa"
              }
            ]
          },
          "source" => "Twitter Web App",
          "reply_settings" => "everyone",
          "id" => "1498253489717264389",
          "text" => "RT @JoshPughComic: Piss Up in a Brewery https://t.co/N3uTkw6Ysa",
          "referenced_tweets" => [{ "type" => "retweeted", "id" => "1498221804552339463" }],
          "context_annotations" => [
            {
              "domain" => {
                "id" => "65",
                "name" => "Interests and Hobbies Vertical",
                "description" => "Top level interests and hobbies groupings, like Food or Travel"
              },
              "entity" => { "id" => "825047692124442624", "name" => "Food", "description" => "Food" }
            },
            {
              "domain" => {
                "id" => "65",
                "name" => "Interests and Hobbies Vertical",
                "description" => "Top level interests and hobbies groupings, like Food or Travel"
              },
              "entity" => { "id" => "834828264786898945", "name" => "Drinks", "description" => "Drinks" }
            }
          ],
          "conversation_id" => "1498253489717264389"
        }
      ]
    end

    subject { described_class.new(api_client: api_client, id: id) }

    it "queries the api client for user fields" do
      query = {
        max_results: max_results,
        start_time: since.utc.iso8601,
        expansions: "attachments.media_keys,attachments.poll_ids,entities.mentions.username",
        "tweet.fields" => "id,created_at,text,referenced_tweets,attachments,withheld,geo,entities,public_metrics,possibly_sensitive,source,lang,context_annotations,conversation_id,reply_settings",
        "media.fields" => "media_key,duration_ms,height,preview_image_url,type,url,width,promoted_metrics,alt_text",
        "poll.fields" => "id,options,voting_status,end_datetime,duration_minutes"
      }

      expect(api_client).to receive(:get).with("/users/#{id}/tweets", query: query)
      subject.tweets(max_results: max_results, since: since)
    end

    it "parses the response" do
      expect(api_client).to receive(:parse).and_return(response)
      subject.tweets(max_results: max_results, since: since)
    end

    context "when something went wrong" do
      before do
        client = Twitter::Api::Client.new
        client.parse("")
        errors = client.errors

        allow(api_client).to receive(:failure?).and_return(true)
        allow(api_client).to receive(:errors).and_return(errors)
      end

      it "fails" do
        subject.tweets(max_results: max_results, since: since)
        expect(subject).to_not be_success
      end

      it "sets an error" do
        subject.tweets(max_results: max_results, since: since)
        expect(subject.errors.full_messages).to include anything
      end

      it "returns nil" do
        expect(subject.tweets(max_results: max_results, since: since)).to be_nil
      end
    end

    context "when all went good" do
      it "succeeds" do
        subject.tweets(max_results: max_results, since: since)
        expect(subject).to be_success
      end

      it "returns an array of API twitter tweets" do
        expect(subject.tweets(max_results: max_results, since: since)).to be_a Array
        expect(subject.tweets(max_results: max_results, since: since).first).to be_a Twitter::Api::Tweet
      end

      it "uses the tweet builder" do
        builder = double
        tweet = double
        expect(builder).to receive(:call).twice
        expect(builder).to receive(:tweet).twice.and_return(tweet)
        expect(Twitter::Api::ParseTweetService).to receive(:new).twice.and_return(builder)
        subject.tweets(max_results: max_results, since: since)
      end

      context "when there's an API twitter user" do
        let(:tweet) { subject.tweets(max_results: max_results, since: since).first }

        it "has a the relevant data" do
          expect(tweet.id).to eq id
          expect(tweet.title).to eq title
          expect(tweet.text).to eq text
          expect(tweet.created_at).to eq created_at
        end
      end
    end
  end
end
