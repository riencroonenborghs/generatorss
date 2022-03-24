require 'rails_helper'

RSpec.describe Website::FindRssFeedsService, type: :service do
  let(:url) { Faker::Internet.url }

  let(:subject) { described_class.call(url: url) }

  shared_examples "the service fails with error" do |error|
    it "fails" do
      expect(subject.failure?).to be true
    end

    it "has the error" do
      expect(subject.errors.full_messages).to include error
    end
  end

  describe "#call" do
    context "when there is no url data" do
      before do
        loader = double
        allow(loader).to receive(:data).and_return(nil)
        allow(loader).to receive(:success?).and_return(true)
        allow(LoadUrlDataService).to receive(:call).with(url: url).and_return(loader)
      end

      it_behaves_like "the service fails with error", "URL has no data"
    end

    context "when it's a tumblr site" do
      let(:url) { "http://catsthatlooklikeronswanson.tumblr.com" }

      it "finds feed" do
        expect(subject.rss_feeds.size).to eq 1
      end

      it "finds the rss feed url" do
        expect(subject.rss_feeds.first.href).to eq "#{url}/rss"
      end

      context "when url ends with /" do
        let(:url) { "http://catsthatlooklikeronswanson.tumblr.com/" }

        it "finds the rss feed url" do
          expect(subject.rss_feeds.first.href).to eq "#{url}rss"
        end
      end
    end

    context "when it's a blogger site" do
      let(:url) { "http://althouse.blogspot.com" }

      it "finds feed" do
        expect(subject.rss_feeds.size).to eq 1
      end

      it "finds the rss feed url" do
        expect(subject.rss_feeds.first.href).to eq "#{url}/feeds/posts/default"
      end

      context "when url ends with /" do
        let(:url) { "http://althouse.blogspot.com/" }

        it "finds the rss feed url" do
          expect(subject.rss_feeds.first.href).to eq "#{url}feeds/posts/default"
        end
      end
    end

    context "when it's a medium site" do
      let(:url) { "https://medium.com/swlh" }

      it "finds feed" do
        expect(subject.rss_feeds.size).to eq 1
      end

      it "finds the rss feed url" do
        expect(subject.rss_feeds.first.href).to eq "https://medium.com/feed/swlh"
      end
    end

    context "when it's a regular site with a relative rss alternate" do
      let(:url) { Faker::Internet.url }

      before do
        loader = double
        data = load_data("websites/relative_alternate.txt")
        allow(loader).to receive(:data).and_return(data)
        allow(loader).to receive(:success?).and_return(true)
        allow(LoadUrlDataService).to receive(:call).with(url: url).and_return(loader)
        LoadUrlDataService.call(url: url)
      end

      it "finds feed" do
        expect(subject.rss_feeds.size).to eq 1
      end

      it "finds the rss feed url" do
        expect(subject.rss_feeds.first.href).to eq "#{url}/rss"
      end
    end

    context "when it's a regular site with a rss alternate" do
      let(:url) { Faker::Internet.url }

      before do
        loader = double
        data = load_data("websites/rss_alternate.txt")
        allow(loader).to receive(:data).and_return(data)
        allow(loader).to receive(:success?).and_return(true)
        allow(LoadUrlDataService).to receive(:call).with(url: url).and_return(loader)
        LoadUrlDataService.call(url: url)
      end

      it "finds feed" do
        expect(subject.rss_feeds.size).to eq 1
      end

      it "finds the rss feed url" do
        expect(subject.rss_feeds.first.href).to eq "https://news.ycombinator.com/rss"
      end
    end

    context "when it's a regular site with a atom alternate" do
      let(:url) { Faker::Internet.url }

      before do
        loader = double
        data = load_data("websites/atom_alternate.txt")
        allow(loader).to receive(:data).and_return(data)
        allow(loader).to receive(:success?).and_return(true)
        allow(LoadUrlDataService).to receive(:call).with(url: url).and_return(loader)
        LoadUrlDataService.call(url: url)
      end

      it "finds feed" do
        expect(subject.rss_feeds.size).to eq 1
      end

      it "finds the rss feed url" do
        expect(subject.rss_feeds.first.href).to eq "https://news.ycombinator.com/rss"
      end
    end

    context "when it's a regular site with multiple rss alternates" do
      let(:url) { Faker::Internet.url }

      before do
        loader = double
        data = load_data("websites/multiple_alternates.txt")
        allow(loader).to receive(:data).and_return(data)
        allow(loader).to receive(:success?).and_return(true)
        allow(LoadUrlDataService).to receive(:call).with(url: url).and_return(loader)
        LoadUrlDataService.call(url: url)
      end

      it "finds feed" do
        expect(subject.rss_feeds.size).to eq 2
      end

      it "finds the rss feeds" do
        first = subject.rss_feeds.first
        expect(first.title).to eq "Main Feed"
        expect(first.href).to eq "https://news.ycombinator.com/rss"

        second = subject.rss_feeds.second
        expect(second.title).to eq "Comments Feed"
        expect(second.href).to eq "https://news.ycombinator.com/comments/rss"
      end
    end

    context "when it's a regular site" do
      let(:url) { Faker::Internet.url }

      before do
        loader = double
        data = load_data("websites/no_alternate.txt")
        allow(loader).to receive(:data).and_return(data)
        allow(loader).to receive(:success?).and_return(true)
        allow(LoadUrlDataService).to receive(:call).with(url: url).and_return(loader)
        LoadUrlDataService.call(url: url)
      end

      it "finds no feed" do
        expect(subject.rss_feeds.size).to eq 0
      end
    end
  end
end
