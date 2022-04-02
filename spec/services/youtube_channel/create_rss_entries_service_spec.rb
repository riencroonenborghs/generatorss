require 'rails_helper'

RSpec.describe YoutubeChannel::CreateRssItemsService, type: :service do
  let(:youtube_channel) { create :youtube_channel, last_loaded: nil }
  subject { described_class.call(youtube_channel: youtube_channel) }

  shared_examples "the service fails with error" do |error|
    it "fails" do
      expect(subject.failure?).to be true
    end

    it "has the error" do
      expect(subject.errors.full_messages).to include error
    end
  end

  describe "#call" do
    context "when loading URL data fails" do
      before do
        object = User.new
        object.errors.add(:base, "Some API error")
        errors = object.errors

        loader = double
        allow(loader).to receive(:errors).and_return(errors)
        allow(loader).to receive(:success?).and_return(false)
        allow(LoadUrlDataService).to receive(:call).and_return(loader)
      end

      it_behaves_like "the service fails with error", "Some API error"
    end

    context "when there is no URL data" do
      before do
        loader = double
        allow(loader).to receive(:data).and_return(nil)
        allow(loader).to receive(:success?).and_return(true)
        allow(LoadUrlDataService).to receive(:call).and_return(loader)
      end

      it_behaves_like "the service fails with error", "URL has no data"
    end

    context "when parsing URL data fails" do
      before do
        loader = double
        allow(loader).to receive(:data).and_return("")
        allow(loader).to receive(:success?).and_return(true)
        allow(LoadUrlDataService).to receive(:call).and_return(loader)
      end

      it_behaves_like "the service fails with error", "No valid parser for XML."
    end

    context "when there is no parsed data" do
      before do
        data = double
        loader = double
        allow(loader).to receive(:data).and_return(data)
        allow(loader).to receive(:success?).and_return(true)
        allow(LoadUrlDataService).to receive(:call).and_return(loader)

        allow(Feedjira).to receive(:parse).with(data).and_return(nil)
      end

      it_behaves_like "the service fails with error", "could not parse RSS data"
    end

    context "when there are no RSS entries" do
      before do
        data = double
        loader = double
        allow(loader).to receive(:data).and_return(data)
        allow(loader).to receive(:success?).and_return(true)
        allow(LoadUrlDataService).to receive(:call).and_return(loader)

        feedjira = double
        allow(feedjira).to receive(:entries).and_return(nil)
        allow(Feedjira).to receive(:parse).with(data).and_return(feedjira)
      end

      it_behaves_like "the service fails with error", "no RSS entries found"
    end

    context "when things go good" do
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
              guid: entry.entry_id
            }
          end
        )
      end

      context "when some RSS entries exist" do
        it "creates only the new RSS entries" do
          create_rss_entries(5)
          expect { subject }.to change(youtube_channel.rss_items, :count).by(10)
        end
      end

      context "when no RSS entries exist" do
        it "creates all the RSS entries" do
          expect { subject }.to change(youtube_channel.rss_items, :count).by(15)
        end
      end
    end
  end
end
