require 'rails_helper'

RSpec.describe SyncSubscriptionsJob, type: :job do
  let!(:user) { create :user }
  let!(:subscription) { create :subscription, user: user, subscriptable: twitter_user }
  let!(:twitter_user) { create :twitter_user }
  let!(:twitter_user_id) { twitter_user.id }

  let(:subject) { described_class.new.perform }

  describe "#perform" do
    it "queues a job" do
      expect { subject }.to change(SyncTwitterUserJob.jobs, :size).by(1)
    end
  end
end
