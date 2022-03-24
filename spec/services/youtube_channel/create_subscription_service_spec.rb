require 'rails_helper'

RSpec.describe YoutubeChannel::CreateSubscriptionService, type: :service do
  let(:user) { create :user }
  let(:url) { Faker::Internet.url }
  let(:rss_url) { Faker::Internet.url }
  let(:name) { Faker::Name.first_name }
  let(:image_url) { Faker::Internet.url }

  let(:subject) { described_class.call(user: user, url: url) }

  before do
    service = double
    allow(service).to receive(:rss_url).and_return(rss_url)
    allow(service).to receive(:name).and_return(name)
    allow(service).to receive(:image_url).and_return(image_url)
    allow(service).to receive(:success?).and_return(true)
    allow(YoutubeChannel::LoadChannelDetailsService).to receive(:call).with(url: url).and_return(service)
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
    context "when an error happened when finding the channel details" do
      before do
        service = double
        object = Twitter::Api::Client.new
        object.errors.add(:base, "Some error")
        errors = object.errors
        allow(service).to receive(:success?).and_return(false)
        allow(service).to receive(:errors).and_return(errors)
        allow(YoutubeChannel::LoadChannelDetailsService).to receive(:call).with(url: url).and_return(service)
      end

      it_behaves_like "the service fails with error", "Some error"
    end

    context "when subscription already exists" do
      let(:youtube_channel) { create :youtube_channel, rss_url: rss_url }
      let!(:subscription) { create :subscription, user: user, subscriptable: youtube_channel }

      it_behaves_like "the service fails with error", "subscription already exists"
    end

    context "when youtube channel does not exist" do
      it "creates the youtube channel" do
        expect { subject }.to change(YoutubeChannel, :count).by(1)
        youtube_channel = YoutubeChannel.last
        expect(youtube_channel.url).to eq url
        expect(youtube_channel.name).to eq name
        expect(youtube_channel.rss_url).to eq rss_url
        expect(youtube_channel.image_url).to eq image_url
      end
    end

    context "when youtube channel creation fails" do
      before do
        youtube_channel = YoutubeChannel.new
        youtube_channel.valid?

        allow_any_instance_of(YoutubeChannel).to receive(:save).and_return(false)
        allow_any_instance_of(YoutubeChannel).to receive(:errors).and_return(youtube_channel.errors)
      end

      it "doesn't create the youtube channel" do
        expect { subject }.to_not change(YoutubeChannel, :count)
      end

      it "doesn't create a subscriptions" do
        expect { subject }.to_not change(Subscription, :count)
      end
    end

    context "when subscription creation fails" do
      before do
        youtube_channel = create :youtube_channel
        subscription = Subscription.new(subscriptable: youtube_channel)
        subscription.valid?

        allow_any_instance_of(Subscription).to receive(:save).and_return(false)
        allow_any_instance_of(Subscription).to receive(:errors).and_return(subscription.errors)
      end

      it_behaves_like "the service fails with error", "User must exist"
    end

    it "creates the subscription" do
      expect { subject }.to change(Subscription, :count).by(1)
      subscription = Subscription.last
      expect(subscription.user).to eq user
      expect(subscription.subscriptable.url).to eq url
    end
  end
end
