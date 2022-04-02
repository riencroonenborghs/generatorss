require 'rails_helper'

RSpec.describe YoutubeChannel::CreateSubscriptionService, type: :service do
  let(:user) { create :user }
  let(:url) { Faker::Internet.url }
  let(:rss_url) { Faker::Internet.url }
  let(:name) { Faker::Name.first_name }
  let(:image_url) { Faker::Internet.url }
  let(:subject) { described_class.call(user: user, url: url) }

  shared_examples "the service fails with error" do |error|
    it "fails" do
      expect(subject.failure?).to be true
    end

    it "has the error" do
      expect(subject.errors.full_messages).to include error
    end
  end

  describe "#call" do
    context "when loading the channel details fails" do
      before do
        service = double
        object = User.new
        object.errors.add(:base, "Some YT channel error")
        errors = object.errors
        allow(service).to receive(:success?).and_return(false)
        allow(service).to receive(:errors).and_return(errors)
        allow(YoutubeChannel::LoadChannelDetailsService).to receive(:call).with(url: url).and_return(service)
      end

      it_behaves_like "the service fails with error", "Some YT channel error"
    end

    it "creates a youtube channel" do
      service = double
      allow(service).to receive(:rss_url).and_return(rss_url)
      allow(service).to receive(:name).and_return(name)
      allow(service).to receive(:image_url).and_return(image_url)
      allow(service).to receive(:success?).and_return(true)
      allow(YoutubeChannel::LoadChannelDetailsService).to receive(:call).with(url: url).and_return(service)

      expect { subject.call }.to change(YoutubeChannel, :count).by(1)
      youtube_channel = YoutubeChannel.last
      expect(youtube_channel.url).to eq url
      expect(youtube_channel.rss_url).to eq rss_url
      expect(youtube_channel.name).to eq name
      expect(youtube_channel.image_url).to eq image_url
    end
  end
end
