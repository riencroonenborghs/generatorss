require 'rails_helper'

RSpec.describe Discord::CreateSubscriptionService, type: :service do
  let(:user) { create :user }
  let(:channel_id) { "channel_id" }
  let(:guild_id) { "guild_id" }
  let(:name) { "name" }
  let(:topic) { "topic" }
  let(:subject) { described_class.call(user: user, channel_id: channel_id) }

  shared_examples "the service fails with error" do |error|
    it "fails" do
      expect(subject.failure?).to be true
    end

    it "has the error" do
      expect(subject.errors.full_messages).to include error
    end
  end

  describe "#call" do
    context "when Discord API fails" do
      before do
        service = double
        object = User.new
        object.errors.add(:base, "Some Discord API error")
        errors = object.errors
        allow(service).to receive(:success?).and_return(false)
        allow(service).to receive(:errors).and_return(errors)
        allow(service).to receive(:details)
        allow(Discord::Api::ChannelService).to receive(:new).and_return(service)
      end

      it_behaves_like "the service fails with error", "Some Discord API error"
    end

    context "when no channel details were found" do
      before do
        service = double
        allow(service).to receive(:success?).and_return(true)
        allow(service).to receive(:details).and_return(nil)
        allow(Discord::Api::ChannelService).to receive(:new).and_return(service)
      end

      it_behaves_like "the service fails with error", "cannot find channel details"
    end

    it "creates a discord channel" do
      service = double
      details = Discord::Api::Channel.new(
        id: 1,
        guild_id: guild_id,
        name: name, 
        topic: topic
      )
      allow(service).to receive(:success?).and_return(true)
      allow(service).to receive(:details).and_return(details)
      allow(Discord::Api::ChannelService).to receive(:new).and_return(service)

      expect { subject.call }.to change(DiscordChannel, :count).by(1)
      discord_channel = DiscordChannel.last
      expect(discord_channel.guild_id).to eq guild_id
      expect(discord_channel.name ).to eq name
      expect(discord_channel.description).to eq topic
    end
  end
end
