require "rails_helper"

RSpec.describe Filters::EngineService, type: :model do
  let(:user) { create :user }

  let!(:entry1) { create :rss_item, :twitter_user, published_at: 10.days.ago }
  let!(:entry2) { create :rss_item, :twitter_user, published_at: 9.days.ago }
  let!(:entry3) { create :rss_item, :twitter_user, published_at: 8.days.ago }
  let!(:entry4) { create :rss_item, :twitter_user, published_at: 7.days.ago }
  let!(:entry5) { create :rss_item, :twitter_user, published_at: 6.days.ago }

  subject { described_class.call filters: filters, scope: RssItem }

  describe ".call" do
    context "when there's no filter" do
      let(:filters) { [] }

      it "does not change the scope" do
        expect(subject.scope).to eq RssItem
      end
    end

    context "when there's one filter" do
      let!(:filter1) { create :filter, user: user, value: "foo" }
      let!(:filters) { [filter1] }

      let(:full_sql) { subject.scope.to_sql }
      let(:where_sql) { full_sql.split("WHERE")[1] }

      # SELECT DISTINCT \"rss_items\".* FROM \"rss_items\" WHERE (NOT ((upper(rss_items.title) like '%FOO%')))

      it "has no OR scope" do
        expect(where_sql.match?("OR")).to be false
      end

      it "has a NOT scope" do
        expect(where_sql.match?("NOT")).to be true
      end
    end
    context "when there's more than one filter" do
      let!(:filter1) { create :filter, user: user, value: "foo" }
      let!(:filter2) { create :filter, user: user, value: "bar" }
      let!(:filter3) { create :filter, user: user, value: "olaf" }
      let!(:filter4) { create :filter, user: user, value: "polaf" }
      let!(:filter5) { create :filter, user: user, value: "quux" }
      let!(:filters) { [filter1, filter2, filter3, filter4, filter5] }

      let(:full_sql) { subject.scope.to_sql }
      let(:where_sql) { full_sql.split("WHERE")[1] }

      # SELECT DISTINCT \"rss_items\".* FROM \"rss_items\" WHERE (NOT ((upper(rss_items.title) like '%FOO%') AND (upper(rss_items.title) like '%BAR%') AND (upper(rss_items.title) like '%OLAF%') AND (upper(rss_items.title) like '%POLAF%') AND (upper(rss_items.title) like '%QUUX%')))"

      it "has a OR scope" do
        expect(where_sql.match?("OR")).to be true
      end

      it "has OR scopes" do
        expect(where_sql.split("OR").count).to eq 4 + 1 # 1 for user id and 4 for AND between the filters
      end

      it "has a NOT scope" do
        expect(where_sql.match?("NOT")).to be true
      end
    end
  end
end
