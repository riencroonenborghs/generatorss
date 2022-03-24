require 'rails_helper'

RSpec.describe Twitter::CreateRssItemsService, type: :service do
  let(:twitter_user) { create :twitter_user, :unloaded }

  let(:subject) { described_class.call(twitter_user: twitter_user) }

  let(:tweet_api_data) do
    [
      {
        "created_at" => "2022-02-25T04:00:02.000Z",
        "source" => "Sprout Social",
        "text" => "C: Woah, woah, take it easy on that curve, fella. https://t.co/0lgqTUBZyH",
        "id" => "1497058783574597632"
      },
      {
        "created_at" => "2022-02-25T03:15:01.000Z",
        "source" => "Sprout Social",
        "text" => "Incredible ‘Sims’ Cosplay: This Guy Pissed Himself And Immediately Cried About It https://t.co/t2KTfAqiqZ https://t.co/1syqSNMjwS",
        "id" => "1497047454893715492"
      },
      {
        "created_at" => "2022-02-25T02:30:02.000Z",
        "source" => "Sprout Social",
        "text" => "On Top Of Everything, Man’s Allergies Also Acting Up https://t.co/jOxyirMu30 https://t.co/hysRjFT2Cj",
        "id" => "1497036133091397633"
      },
      {
        "created_at" => "2022-02-25T02:00:09.000Z",
        "source" => "Sprout Social",
        "text" => "Spongebob Squarepants (Gin for Kids): Critics say that a cartoon partnering with a liquor brand will encourage underage drinking, but children love it. https://t.co/BwKxvOlZAr",
        "id" => "1497028614403104773"
      },
      {
        "created_at" => "2022-02-25T01:45:01.000Z",
        "source" => "Sprout Social",
        "text" => "Knee To Hurt For Rest Of Life After 30-Year-Old Woman Sits Awkwardly For 2 Minutes https://t.co/gO5gsiWq9n https://t.co/tBv22MN69P",
        "id" => "1497024805358473216"
      }
    ]
  end

  before do
    service = double
    tweets = tweet_api_data.map do |tweet|
      Twitter::Api::Tweet.new(
        id: tweet["id"],
        title: tweet["text"],
        text: tweet["text"],
        created_at: tweet["created_at"]
      )
    end
    allow(service).to receive(:tweets).and_return(tweets)
    allow(service).to receive(:success?).and_return(true)
    allow(Twitter::Api::UsersService).to receive(:new).and_return(service)
  end

  def create_tweets(number)
    tweet_api_data.slice(0, number).each do |datum|
      service = Twitter::Api::ParseTweetService.new(data: datum)
      service.call
      api_tweet = service.tweet
      twitter_user.rss_items.create!(
        title: api_tweet.title,
        link: "https://twitter.com/#{twitter_user.username}/status/#{api_tweet.id}",
        published_at: api_tweet.created_at,
        description: api_tweet.text,
        guid: api_tweet.id
      )
    end
  end

  shared_examples "the service fails with error" do |error|
    it "fails" do
      expect(subject.failure?).to be true
    end

    it "has the error" do
      expect(subject.errors.full_messages).to include error
    end
  end

  describe "#call" do
    context "when api call fails" do
      before do
        service = double
        object = Twitter::Api::Client.new
        object.errors.add(:base, "Some error")
        errors = object.errors
        allow(service).to receive(:success?).and_return(false)
        allow(service).to receive(:errors).and_return(errors)
        allow(service).to receive(:tweets)
        allow(Twitter::Api::UsersService).to receive(:new).and_return(service)
      end

      it_behaves_like "the service fails with error", "Some error"
    end

    context "when some tweets exist" do
      it "creates only the new tweets" do
        create_tweets(3)
        expect { subject }.to change(twitter_user.rss_items, :count).by(2)
      end
    end

    context "when no tweets exist" do
      it "creates all the tweets" do
        expect { subject }.to change(twitter_user.rss_items, :count).by(5)
      end
    end

    it "sets last loaded" do
      travel_to(Time.zone.now) do
        expect { subject }.to change { twitter_user.last_loaded }.from(nil).to(Time.zone.now)
      end
    end
  end
end
