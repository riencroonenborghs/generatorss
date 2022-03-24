require 'rails_helper'

RSpec.describe CleanOldRssItemsJob, type: :job do
  let(:subject) { described_class.new.perform }

  describe "#perform" do
    it "keeps tweets" do
      (1..10).each do |i|
        create(:rss_item, :twitter_user, published_at: i.days.ago)
      end

      expect { subject }.to_not change(RssItem, :count)
    end

    it "removes tweets" do
      (25..34).each do |i|
        create(:rss_item, :twitter_user, published_at: i.days.ago)
      end

      expect { subject }.to change(RssItem, :count).from(10).to(5)
    end
  end
end
