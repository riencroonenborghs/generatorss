require 'rails_helper'

RSpec.describe CreateRssItemsService, type: :service do
  let(:subscriptable) { create :twitter_user, last_loaded: nil }
  subject { described_class.new(subscriptable: subscriptable) }

  describe "#call" do
    context "when entry has content" do
      before do
        entries = [
          Struct.new(:title, :link, :published_at, :content, :guid).new(
            "title", "link", Time.zone.now, "content", "guid"
          )
        ]
        allow(subject).to receive(:entries_to_add).and_return(entries)
      end

      it "sets the description" do
        expect { subject.call }.to change(RssItem, :count).by(1)
        rss_item = RssItem.last
        expect(rss_item.description).to eq "content"
      end
    end

    context "when entry has summary" do
      before do
        entries = [
          Struct.new(:title, :link, :published_at, :summary, :guid).new(
            "title", "link", Time.zone.now, "summary", "guid"
          )
        ]
        allow(subject).to receive(:entries_to_add).and_return(entries)
      end

      it "sets the description" do
        expect { subject.call }.to change(RssItem, :count).by(1)
        rss_item = RssItem.last
        expect(rss_item.description).to eq "summary"
      end
    end

    context "when entry has description" do
      before do
        entries = [
          Struct.new(:title, :link, :published_at, :description, :guid).new(
            "title", "link", Time.zone.now, "description", "guid"
          )
        ]
        allow(subject).to receive(:entries_to_add).and_return(entries)
      end

      it "sets the description" do
        expect { subject.call }.to change(RssItem, :count).by(1)
        rss_item = RssItem.last
        expect(rss_item.description).to eq "description"
      end
    end

    context "when entry has url" do
      before do
        entries = [
          Struct.new(:title, :url, :published_at, :description, :guid).new(
            "title", "url", Time.zone.now, "description", "guid"
          )
        ]
        allow(subject).to receive(:entries_to_add).and_return(entries)
      end

      it "sets the link" do
        expect { subject.call }.to change(RssItem, :count).by(1)
        rss_item = RssItem.last
        expect(rss_item.link).to eq "url"
      end
    end

    context "when entry has link" do
      before do
        entries = [
          Struct.new(:title, :link, :published_at, :description, :guid).new(
            "title", "link", Time.zone.now, "description", "guid"
          )
        ]
        allow(subject).to receive(:entries_to_add).and_return(entries)
      end

      it "sets the link" do
        expect { subject.call }.to change(RssItem, :count).by(1)
        rss_item = RssItem.last
        expect(rss_item.link).to eq "link"
      end
    end

    context "when entry has published" do
      before do
        entries = [
          Struct.new(:title, :link, :published, :description, :guid).new(
            "title", "link", Time.zone.now, "description", "guid"
          )
        ]
        allow(subject).to receive(:entries_to_add).and_return(entries)
      end

      it "sets the published at" do
        expect { subject.call }.to change(RssItem, :count).by(1)
        rss_item = RssItem.last
        expect(rss_item.published_at).to_not be_nil
      end
    end

    context "when entry has published_at" do
      before do
        entries = [
          Struct.new(:title, :link, :published_at, :description, :guid).new(
            "title", "link", Time.zone.now, "description", "guid"
          )
        ]
        allow(subject).to receive(:entries_to_add).and_return(entries)
      end

      it "sets the published at" do
        expect { subject.call }.to change(RssItem, :count).by(1)
        rss_item = RssItem.last
        expect(rss_item.published_at).to_not be_nil
      end
    end

    context "when entry has guid" do
      before do
        entries = [
          Struct.new(:title, :link, :published_at, :description, :guid).new(
            "title", "link", Time.zone.now, "description", "guid"
          )
        ]
        allow(subject).to receive(:entries_to_add).and_return(entries)
      end

      it "sets the guid" do
        expect { subject.call }.to change(RssItem, :count).by(1)
        rss_item = RssItem.last
        expect(rss_item.guid).to eq "guid"
      end
    end

    context "when entry has entry id" do
      before do
        entries = [
          Struct.new(:title, :link, :published_at, :description, :entry_id).new(
            "title", "link", Time.zone.now, "description", "entry_id"
          )
        ]
        allow(subject).to receive(:entries_to_add).and_return(entries)
      end

      it "sets the guid" do
        expect { subject.call }.to change(RssItem, :count).by(1)
        rss_item = RssItem.last
        expect(rss_item.guid).to eq "entry_id"
      end
    end

    context "when entry has no title" do
      before do
        entries = [
          Struct.new(:link, :published_at, :description, :entry_id).new(
            "link", Time.zone.now, "description", "entry_id"
          )
        ]
        allow(subject).to receive(:entries_to_add).and_return(entries)
      end

      it "sets uses the description" do
        expect { subject.call }.to change(RssItem, :count).by(1)
        rss_item = RssItem.last
        expect(rss_item.title).to eq "description"
      end
    end

    context "when entry has no title, but a description with dots" do
      before do
        entries = [
          Struct.new(:link, :published_at, :description, :entry_id).new(
            "link", Time.zone.now, "A long description. That has dots.", "entry_id"
          )
        ]
        allow(subject).to receive(:entries_to_add).and_return(entries)
      end

      it "sets uses the description before the first dot" do
        expect { subject.call }.to change(RssItem, :count).by(1)
        rss_item = RssItem.last
        expect(rss_item.title).to eq "A long description"
      end
    end

    context "when entry has no title, but a description with \\n" do
      before do
        entries = [
          Struct.new(:link, :published_at, :description, :entry_id).new(
            "link", Time.zone.now, "A description \n with backslash n.", "entry_id"
          )
        ]
        allow(subject).to receive(:entries_to_add).and_return(entries)
      end

      it "sets uses the description stripped" do
        expect { subject.call }.to change(RssItem, :count).by(1)
        rss_item = RssItem.last
        expect(rss_item.title).to eq "A description  with backslash n"
      end
    end

    context "when entry has title" do
      before do
        entries = [
          Struct.new(:title, :link, :published_at, :description, :entry_id).new(
            "title", "link", Time.zone.now, "description", "entry_id"
          )
        ]
        allow(subject).to receive(:entries_to_add).and_return(entries)
      end

      it "sets uses the title" do
        expect { subject.call }.to change(RssItem, :count).by(1)
        rss_item = RssItem.last
        expect(rss_item.title).to eq "title"
      end
    end

    it "updates last loaded" do
      travel_to(Time.zone.now) do
        allow(subject).to receive(:entries_to_add).and_return([])
        expect { subject.call }.to change { subscriptable.last_loaded }.from(nil).to(Time.zone.now)
      end
    end
  end
end
