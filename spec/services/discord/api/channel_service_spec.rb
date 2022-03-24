require "rails_helper"

RSpec.describe Discord::Api::ChannelService, type: :service do
  describe "#details" do
    let(:client) { double }
    let(:channel_id) { "channel_id" }

    subject { described_class.new(client: client, channel_id: channel_id) }

    context "when the client fails" do
      before do
        object = User.new
        object.errors.add(:base, "some error")
        errors = object.errors

        expect(client).to receive(:get).with("/channels/#{channel_id}").and_return(nil)
        expect(client).to receive(:failure?).and_return(true)
        expect(client).to receive(:errors).and_return(errors)
      end

      it "fails" do
        subject.details
        expect(subject.failure?).to be_truthy
      end

      it "sets errors" do
        subject.details
        expect(subject.errors.full_messages).to include("some error")
      end

      it "returns nil" do
        expect(subject.details).to eq(nil)
      end
    end

    context "when the client succeeds" do
      let(:data) { { } }

      before do
        expect(client).to receive(:get).with("/channels/#{channel_id}").and_return(data)
        expect(client).to receive(:failure?).and_return(false)
      end

      it "succeeds" do
        subject.details
        expect(subject.success?).to be_truthy
      end

      it "builds the channel" do
        expect(Discord::Api::Channel).to receive(:build_from).with(data).and_return(nil)
        subject.details
      end
    end
  end

  describe "#messages" do
    let(:client) { double }
    let(:channel_id) { "channel_id" }

    subject { described_class.new(client: client, channel_id: channel_id) }

    context "when the client fails" do
      before do
        object = User.new
        object.errors.add(:base, "some error")
        errors = object.errors

        expect(client).to receive(:get).with("/channels/#{channel_id}/messages").and_return(nil)
        expect(client).to receive(:failure?).and_return(true)
        expect(client).to receive(:errors).and_return(errors)
      end

      it "fails" do
        subject.messages
        expect(subject.failure?).to be_truthy
      end

      it "sets errors" do
        subject.messages
        expect(subject.errors.full_messages).to include("some error")
      end

      it "returns an empty array" do
        expect(subject.messages).to eq([])
      end
    end

    context "when the client succeeds" do
      let(:data) { [{ "timestamp" => Time.zone.now.iso8601 }] }

      before do
        expect(client).to receive(:get).with("/channels/#{channel_id}/messages").and_return(data)
        expect(client).to receive(:failure?).and_return(false)
      end

      it "succeeds" do
        subject.messages
        expect(subject.success?).to be_truthy
      end

      it "builds the messages" do
        expect(Discord::Api::Message).to receive(:build_from)
        subject.messages
      end
    end
  end
end
