require 'rails_helper'

RSpec.describe RssFeedsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]

    10.times do
      youtube_channel = create :youtube_channel
      user.subscriptions.create!(subscriptable: youtube_channel)
    end
  end

  describe "GET show" do
    let(:user) { create :user }
    let(:params) { { uuid: user.subscriptions.last.uuid } }

    subject { get :show, params: params, format: :rss }

    context "when subscription UUID is not found" do
      let(:params) { { uuid: "something" } }

      it "redirects to the root path" do
        expect(subject).to redirect_to(root_path)
      end
    end

    it "sets @subscription" do
      subject
      expect(assigns(:subscription)).to_not be_nil
    end
  end
end
