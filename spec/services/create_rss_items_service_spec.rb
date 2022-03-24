require 'rails_helper'

RSpec.describe CreateRssItemsService, type: :service do
  let(:youtube_channel) { create :youtube_channel, :unloaded }

  let(:subject) { described_class.call(subscriptable: youtube_channel) }
  let(:data) { load_data("youtube_channels/rss_entries.xml") }

  before do
    loader = double
    allow(loader).to receive(:data).and_return(data)
    allow(loader).to receive(:success?).and_return(true)
    allow(LoadUrlDataService).to receive(:call).and_return(loader)
  end

  def create_rss_entries(number)
    parsed_data = Feedjira.parse(data)
    entries = parsed_data.entries

    youtube_channel.rss_items.create!(
      entries.slice(0, number).map do |entry|
        {
          title: entry.title,
          link: entry.url,
          published_at: entry.published,
          description: entry.content,
          # media: build_media(entry),
          guid: entry.entry_id
        }
      end
    )
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
    context "when url data loader fails" do
      before do
        object = Twitter::Api::Client.new
        object.errors.add(:base, "Some error")
        errors = object.errors

        loader = double
        allow(loader).to receive(:errors).and_return(errors)
        allow(loader).to receive(:success?).and_return(false)
        allow(LoadUrlDataService).to receive(:call).and_return(loader)
      end

      it_behaves_like "the service fails with error", "Some error"
    end

    context "when url data loader has no data" do
      before do
        loader = double
        allow(loader).to receive(:data).and_return(nil)
        allow(loader).to receive(:success?).and_return(true)
        allow(LoadUrlDataService).to receive(:call).and_return(loader)
      end

      it_behaves_like "the service fails with error", "URL has no data"
    end

    context "when feedjira parsing fails" do
      before do
        allow(Feedjira).to receive(:parse).and_return(nil)
      end

      it_behaves_like "the service fails with error", "could not parse RSS data"
    end

    context "when feedjira has no entries" do
      before do
        parsed_data = double
        allow(parsed_data).to receive(:entries).and_return nil
        allow(Feedjira).to receive(:parse).and_return(parsed_data)
      end

      it_behaves_like "the service fails with error", "no RSS entries found"
    end

    context "when some rss entries exist" do
      it "creates only the new rss entries" do
        create_rss_entries(5)
        expect { subject }.to change(youtube_channel.rss_items, :count).by(10)
      end
    end

    context "when no tweets exist" do
      it "creates all the tweets" do
        expect { subject }.to change(youtube_channel.rss_items, :count).by(15)
      end
    end

    it "sets last loaded" do
      travel_to(Time.zone.now) do
        expect { subject }.to change { youtube_channel.last_loaded }.from(nil).to(Time.zone.now)
      end
    end
  end
end
