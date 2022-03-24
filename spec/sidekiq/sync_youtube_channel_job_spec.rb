require "rails_helper"
require "sidekiq/testing"
Sidekiq::Testing.fake!

RSpec.describe SyncYoutubeChannelJob, type: :job do
  let!(:user) { create :user }
  let!(:youtube_channel) { create :youtube_channel }
  let!(:subscription) { create :subscription, user: user, subscriptable: youtube_channel }
  let(:channel_id) { create :youtube_channel }

  let(:subject) { described_class.new.perform(channel_id) }

  describe "#perform" do
    context "when youtube channel does not exist" do
      let(:subject) { described_class.new.perform("channel_id") }

      it "does nothing" do
        expect(YoutubeChannel::CreateRssItemsService).to_not receive(:call)
        subject
      end
    end

    it "calls the create rss items service" do
      expect(YoutubeChannel::CreateRssItemsService).to receive(:call).with(youtube_channel: instance_of(YoutubeChannel))
      subject
    end
  end
end
