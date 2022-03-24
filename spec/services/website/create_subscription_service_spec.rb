require 'rails_helper'

RSpec.describe Website::CreateSubscriptionService, type: :service do
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
    context "when loading the URL data fails" do
      before do
        service = double
        object = User.new
        object.errors.add(:base, "Some URL loading error")
        errors = object.errors
        allow(service).to receive(:success?).and_return(false)
        allow(service).to receive(:errors).and_return(errors)
        allow(LoadUrlDataService).to receive(:call).with(url: url).and_return(service)
      end

      it_behaves_like "the service fails with error", "Some URL loading error"
    end

    context "when there is no URL data" do
      before do
        service = double
        allow(service).to receive(:success?).and_return(true)
        allow(service).to receive(:data).and_return(nil)
        allow(LoadUrlDataService).to receive(:call).with(url: url).and_return(service)
      end

      it_behaves_like "the service fails with error", "URL has no data"
    end

    context "when no name was found" do
      before do
        service = double
        data = "<html></html>"
        allow(service).to receive(:success?).and_return(true)
        allow(service).to receive(:data).and_return(data)
        allow(LoadUrlDataService).to receive(:call).with(url: url).and_return(service)
      end

      it_behaves_like "the service fails with error", "no name found"
    end

    context "when loading RSS data failed" do
      before do
        url_data_service = double
        data = "<html><title>some name</title></html>"
        allow(url_data_service).to receive(:success?).and_return(true)
        allow(url_data_service).to receive(:data).and_return(data)
        allow(LoadUrlDataService).to receive(:call).with(url: url).and_return(url_data_service)

        rss_service = double
        object = User.new
        object.errors.add(:base, "Some RSS loading error")
        errors = object.errors
        allow(rss_service).to receive(:success?).and_return(false)
        allow(rss_service).to receive(:errors).and_return(errors)
        allow(Website::FindRssFeedsService).to receive(:call).with(url: url).and_return(rss_service)
      end

      it_behaves_like "the service fails with error", "Some RSS loading error"
    end

    context "when no RSS URL was found" do
      before do
        url_data_service = double
        data = "<html><title>#{name}</title></html>"
        allow(url_data_service).to receive(:success?).and_return(true)
        allow(url_data_service).to receive(:data).and_return(data)
        allow(LoadUrlDataService).to receive(:call).with(url: url).and_return(url_data_service)

        rss_service = double
        allow(rss_service).to receive(:success?).and_return(true)
        allow(rss_service).to receive(:rss_feeds).and_return(nil)
        allow(Website::FindRssFeedsService).to receive(:call).with(url: url).and_return(rss_service)
      end

      it_behaves_like "the service fails with error", "no RSS URL found"
    end

    it "creates a website" do
      url_data_service = double
      data = "<html><title>#{name}</title></html>"
      allow(url_data_service).to receive(:success?).and_return(true)
      allow(url_data_service).to receive(:data).and_return(data)
      allow(LoadUrlDataService).to receive(:call).with(url: url).and_return(url_data_service)

      rss_service = double
      rss_feeds = [
        Website::FindRssFeedsService::RssFeed.new(href: rss_url, title: "title")
      ]
      allow(rss_service).to receive(:success?).and_return(true)
      allow(rss_service).to receive(:rss_feeds).and_return(rss_feeds)
      allow(Website::FindRssFeedsService).to receive(:call).with(url: url).and_return(rss_service)

      expect { subject.call }.to change(Website, :count).by(1)
      website = Website.last
      expect(website.url).to eq url
      expect(website.rss_url).to eq rss_url
      expect(website.name ).to eq name
    end
  end
end
