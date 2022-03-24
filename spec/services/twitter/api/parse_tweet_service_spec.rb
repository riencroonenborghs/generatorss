require "rails_helper"

RSpec.describe Twitter::Api::ParseTweetService, type: :service do
  let(:text) { "@robdelaney TC TUGGERS @ITYSL" }
  let(:data) do
    {
      "public_metrics" => {
        "retweet_count" => 0, "reply_count" => 0, "like_count" => 18, "quote_count" => 0
      },
      "text" => text,
      "source" => "Twitter for iPhone",
      "reply_settings" => "everyone",
      "lang" => "nl",
      "id" => "1500183766064455680",
      "created_at" => "2022-03-05T18:57:36.000Z",
      "referenced_tweets" => [{ "type" => "replied_to", "id" => "1500095273124700166" }],
      "possibly_sensitive" => false,
      "conversation_id" => "1500095273124700166",
      "entities" => {
        "mentions" => [
          { "start" => 0, "end" => 11, "username" => "robdelaney", "id" => "22084427" },
          { "start" => 23, "end" => 29, "username" => "ITYSL", "id" => "1080081315146420224" }
        ]
      }
    }
  end

  subject { described_class.new(data: data) }

  describe "#call" do
    it "returns an API tweet object" do
      expect(subject.call).to be_a Twitter::Api::Tweet
    end

    context "when API tweet object is returned" do
      context "when title is short" do
        it "has a full title" do
          expect(subject.call.title).to eq text
        end
      end

      context "when title is long" do
        let(:text) { "Some long text with many characters that no doubt will be truncated given the opportunity when it's long enough to be truncated" }

        it "has a truncated title" do
          expect(subject.call.title).to eq "Some long text with many characters that no doubt will be truncated given the opportunity when it's ..."
        end
      end

      context "when it has mentions" do
        it "replaces mentions" do
          tweet = subject.call
          expect(tweet.text).to include "<a href='https://twitter.com/22084427' title='@robdelaney' target='_blank'>@robdelaney</a>"
        end
      end

      context "when it has urls" do
        let(:text) { "some text https://t.co/10t1SERSlV" }
        let(:data) do
          {
            "public_metrics" => {
              "retweet_count" => 0, "reply_count" => 0, "like_count" => 18, "quote_count" => 0
            },
            "text" => text,
            "source" => "Twitter for iPhone",
            "reply_settings" => "everyone",
            "lang" => "nl",
            "id" => "1500183766064455680",
            "created_at" => "2022-03-05T18:57:36.000Z",
            "referenced_tweets" => [{ "type" => "replied_to", "id" => "1500095273124700166" }],
            "possibly_sensitive" => false,
            "conversation_id" => "1500095273124700166",
            "entities" => {
              "urls" => [
                {
                  "start" => 34,
                  "end" => 57,
                  "url" => "https://t.co/10t1SERSlV",
                  "expanded_url" => "https://theoatmeal.com/comics/universe_cat",
                  "display_url" => "https://theoatmeal.com/comics/universe_cat",
                  "status" => 200,
                  "title" => "I can hear the universe changing",
                  "unwound_url" => "https://theoatmeal.com/comics/universe_cat"
                }
              ]
            }
          }
        end

        it "replaces urls" do
          tweet = subject.call
          expect(tweet.text).to_not include "https://t.co/10t1SERSlV"
          expect(tweet.text).to include "<a href='https://theoatmeal.com/comics/universe_cat' title='https://theoatmeal.com/comics/universe_cat' target='_blank'>I can hear the universe changing</a>"
        end
      end
    end
  end
end
