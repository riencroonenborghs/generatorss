require 'rails_helper'

RSpec.describe Twitter::CreateSubscriptionService, type: :service do
  let(:user) { create :user }
  let(:name) { Faker::Name.first_name }
  let(:twitter_id) { "1" }
  let(:username) { Faker::Name.first_name }
  let(:url_or_handle) { "https://twitter.com/#{name}" }
  let(:subject) { described_class.call(user: user, url_or_handle: url_or_handle) }

  shared_examples "the service fails with error" do |error|
    it "fails" do
      expect(subject.failure?).to be true
    end

    it "has the error" do
      expect(subject.errors.full_messages).to include error
    end
  end

  describe "#call" do
    context "when no valid Twitter URL or handle" do
      let(:url_or_handle) { "lolwut?" }
      it_behaves_like "the service fails with error", "not a Twitter URL or handle"
    end

    context "when Twitter URL is invalid" do
      let(:url_or_handle) { "https://twitter.com/" }
      it_behaves_like "the service fails with error", "missing name from Twitter URL"
    end

    context "when Twitter handle is invalid" do
      let(:url_or_handle) { "@" }
      it_behaves_like "the service fails with error", "missing name from Twitter handle"
    end

    context "when Twitter API fails" do
      before do
        service = double
        object = User.new
        object.errors.add(:base, "Some API error")
        errors = object.errors
        allow(service).to receive(:success?).and_return(false)
        allow(service).to receive(:errors).and_return(errors)
        allow(service).to receive(:find_by)
        allow(Twitter::Api::UsersService).to receive(:new).and_return(service)
      end

      it_behaves_like "the service fails with error", "Some API error"
    end

    context "when Twitter API cannot find the user" do
      before do
        service = double
        allow(service).to receive(:success?).and_return(true)
        allow(service).to receive(:find_by).and_return(nil)
        allow(Twitter::Api::UsersService).to receive(:new).and_return(service)
      end

      it_behaves_like "the service fails with error", "cannot find Twitter API user"
    end

    it "creates a twitter user" do
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

      expect { subject.call }.to change(TwitterUser, :count).by(1)
      twitter_user = TwitterUser.last
      expect(twitter_user.twitter_id).to eq twitter_api_user.id
    end
  end
end
