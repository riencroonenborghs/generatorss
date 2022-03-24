require 'rails_helper'

RSpec.describe YoutubeChannel::LoadChannelDetailsService, type: :service do
  let(:url) { Faker::Internet.url }
  let(:data) { load_data("youtube_channels/full.txt") }

  let(:subject) { described_class.call(url: url) }

  before do
    loader = double
    allow(loader).to receive(:success?).and_return(true)
    allow(loader).to receive(:data).and_return(data)
    allow(LoadUrlDataService).to receive(:call).with(url: url).and_return(loader)
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
    context "when url is wrong" do
      let(:url) { "foo" }

      before do
        allow(LoadUrlDataService).to receive(:call).with(url: url).and_call_original
      end

      it_behaves_like "the service fails with error", "not a valid URL"
    end

    context "when there is no url data" do
      before do
        service = double
        allow(service).to receive(:success?).and_return(true)
        allow(service).to receive(:data).and_return(nil)
        allow(LoadUrlDataService).to receive(:call).with(url: url).and_return(service)
      end

      it_behaves_like "the service fails with error", "URL has no data"
    end

    context "when there is no rss url" do
      let(:data) { load_data("youtube_channels/no_rss_url.txt") }

      it_behaves_like "the service fails with error", "no RSS URL found"
    end

    context "when there is no name" do
      let(:data) { load_data("youtube_channels/no_name.txt") }

      it_behaves_like "the service fails with error", "no name found"
    end

    context "when there is no image url" do
      let(:data) { load_data("youtube_channels/no_image_url.txt") }

      it_behaves_like "the service fails with error", "no image URL found"
    end

    it "has a rss url" do
      expect(subject.rss_url).to eq "https://www.youtube.com/feeds/videos.xml?channel_id=UCb31gOY6OD8ES0zP8M0GhAw"
    end

    it "has a name" do
      expect(subject.name).to eq "Max Fosh"
    end

    it "has a image url" do
      expect(subject.image_url).to eq "https://yt3.ggpht.com/ytc/AKedOLR7fFx57lvf905rIKIVlIPhFUhzrXaT9c7cNl0keg=s900-c-k-c0x00ffffff-no-rj"
    end
  end
end
