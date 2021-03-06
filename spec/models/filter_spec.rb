require "rails_helper"

RSpec.describe Filter, type: :model do
  let(:scope) { double }
  let(:value) { "value" }

  subject { described_class.new(comparison: comparison, value: value) }

  describe ".chain" do
    context "when comma separate values" do
      let(:scope) { RssItem }
      let(:comparison) { "eq" }
      let(:value) { "foo,bar,baz" }
      let(:full_sql)  { subject.chain(scope).to_sql }

      it "chains with AND" do
        expect(full_sql.match?("AND")).to be true
      end

      it "has 3 AND parts" do
        expect(full_sql.split("AND").count).to eq 3
      end

      it "has where cluase for each value" do
        expect(full_sql).to include("upper(rss_items.title) like '%FOO%'")
        expect(full_sql).to include("upper(rss_items.title) like '%BAR%'")
        expect(full_sql).to include("upper(rss_items.title) like '%BAZ%'")
      end
    end

    context "when eq" do
      let(:comparison) { "eq" }

      it "chains with like" do
        expect(scope).to receive(:where).with("upper(rss_items.title) like ?", "%#{value.upcase}%")
        subject.chain(scope)
      end
    end

    context "when ne" do
      let(:comparison) { "ne" }

      it "chains with not like" do
        expect(scope).to receive(:where).with("upper(rss_items.title) not like ?", "%#{value.upcase}%")
        subject.chain(scope)
      end
    end

    context "when something else" do
      let(:comparison) { "gt" }

      it "chains with like" do
        expect(scope).to receive(:where).with("upper(rss_items.title) like ?", "%#{value.upcase}%")
        subject.chain(scope)
      end
    end
  end
end
