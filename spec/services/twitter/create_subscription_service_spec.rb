require 'rails_helper'

RSpec.describe Twitter::CreateSubscriptionService, type: :service do
  let(:user) { create :user }
  let(:twitter_id) { "1" }
  let(:name) { Faker::Name.first_name }
  let(:username) { Faker::Name.first_name }
  let(:twitter_url_or_handle) { "https://twitter.com/#{name}" }

  let(:subject) { described_class.call(user: user, url_or_handle: twitter_url_or_handle) }

  before do
    service = double
    twitter_api_user = Twitter::Api::User.new(
      description: "Some description",
      name: name,
      verified: true,
      url: Faker::Internet.url,
      profile_image_url: Faker::Internet.url,
      id: twitter_id,
      username: username
    )
    allow(service).to receive(:success?).and_return(true)
    allow(service).to receive(:find_by).and_return(twitter_api_user)
    allow(Twitter::Api::UsersService).to receive(:new).and_return(service)
  end

  shared_examples "the service fails with error" do |error|
    it "fails" do
      expect(subject.failure?).to be true
    end

    it "has the error" do
      expect(subject.errors.full_messages).to include error
    end
  end

  describe "#call" do
    context "when providing a twitter URL" do
      context "when twitter URL is all wrong" do
        let(:twitter_url_or_handle) { "https://twitter.com/" }

        it_behaves_like "the service fails with error", "missing name from Twitter URL"
      end
    end

    context "when providing a twitter handle" do
      context "when twitter handle is all wrong" do
        let(:twitter_url_or_handle) { "@" }

        it_behaves_like "the service fails with error", "missing name from Twitter handle"
      end
    end

    context "when not providing a twitter URL or handle" do
      let(:twitter_url_or_handle) { "lolwut?" }

      it_behaves_like "the service fails with error", "not a Twitter URL or handle"
    end

    context "when an error happened when finding the twitter user" do
      before do
        service = double
        object = Twitter::Api::Client.new
        object.errors.add(:base, "Some error")
        errors = object.errors
        allow(service).to receive(:success?).and_return(false)
        allow(service).to receive(:errors).and_return(errors)
        allow(service).to receive(:find_by)
        allow(Twitter::Api::UsersService).to receive(:new).and_return(service)
      end

      it_behaves_like "the service fails with error", "Some error"
    end

    context "when subscription already exists" do
      let(:twitter_user) { create :twitter_user, twitter_id: twitter_id }
      let!(:subscription) { create :subscription, user: user, subscriptable: twitter_user }

      it_behaves_like "the service fails with error", "subscription already exists"
    end

    context "when twitter user does not exist" do
      it "creates the twitter user" do
        expect { subject }.to change(TwitterUser, :count).by(1)
        twitter_user = TwitterUser.last
        expect(twitter_user.twitter_id).to eq twitter_id
        expect(twitter_user.name).to eq name
        expect(twitter_user.username).to eq username
      end
    end

    context "when twitter user creation fails" do
      before do
        twitter_user = TwitterUser.new
        twitter_user.valid?

        allow_any_instance_of(TwitterUser).to receive(:save).and_return(false)
        allow_any_instance_of(TwitterUser).to receive(:errors).and_return(twitter_user.errors)
      end

      it "doesn't create the twitter user" do
        expect { subject }.to_not change(TwitterUser, :count)
      end

      it "doesn't create a subscriptions" do
        expect { subject }.to_not change(Subscription, :count)
      end
    end

    context "when subscription creation fails" do
      before do
        twitter_user = create :twitter_user
        subscription = Subscription.new(subscriptable: twitter_user)
        subscription.valid?

        allow_any_instance_of(Subscription).to receive(:save).and_return(false)
        allow_any_instance_of(Subscription).to receive(:errors).and_return(subscription.errors)
      end

      it_behaves_like "the service fails with error", "User must exist"
    end

    it "creates the subscription" do
      expect { subject }.to change(Subscription, :count).by(1)
      subscription = Subscription.last
      expect(subscription.user).to eq user
      expect(subscription.subscriptable.twitter_id).to eq twitter_id
    end
  end
end
