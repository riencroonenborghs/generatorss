require "rails_helper"
require "sidekiq/testing"
Sidekiq::Testing.fake!

RSpec.describe SyncTwitterUserJob, type: :job do
  let!(:user) { create :user }
  let!(:subscription) { create :subscription, user: user, subscriptable: twitter_user }
  let(:twitter_user) { create :twitter_user }
  let(:twitter_user_id) { twitter_user.id }

  let(:subject) { described_class.new.perform(twitter_user_id) }

  describe "#perform" do
    context "when twitter user does not exist" do
      let(:subject) { described_class.new.perform("twitter_user_id") }

      it "does nothing" do
        expect(Twitter::CreateRssItemsService).to_not receive(:call)
        subject
      end
    end

    it "calls the create tweets service" do
      expect(Twitter::CreateRssItemsService).to receive(:call).with(twitter_user: instance_of(TwitterUser))
      subject
    end
  end
end
