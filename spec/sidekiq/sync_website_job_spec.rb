require "rails_helper"
require "sidekiq/testing"
Sidekiq::Testing.fake!

RSpec.describe SyncWebsiteJob, type: :job do
  let!(:user) { create :user }
  let!(:website) { create :website }
  let!(:subscription) { create :subscription, user: user, subscriptable: website }

  let(:subject) { described_class.new.perform(website.id) }

  describe "#perform" do
    context "when website does not exist" do
      let(:subject) { described_class.new.perform("channel_id") }

      it "does nothing" do
        expect(Website::CreateRssItemsService).to_not receive(:call)
        subject
      end
    end

    it "calls the create rss items service" do
      expect(Website::CreateRssItemsService).to receive(:call).with(website: instance_of(Website))
      subject
    end
  end
end
