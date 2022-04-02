require 'rails_helper'

RSpec.describe CreateSubscriptionService, type: :service do
  let(:user) { create :user }
  let(:input) { "input" }
  let(:subscriptable_class) { TwitterUser }
  let(:twitter_user) { create :twitter_user }

  subject { described_class.new(user: user, input: input, subscriptable_class: subscriptable_class) }

  shared_examples "the service fails with error" do |error|
    it "fails" do
      subject.call
      expect(subject.failure?).to be true
    end

    it "has the error" do
      subject.call
      expect(subject.errors.full_messages).to include error
    end
  end

  describe "#call" do
    context "when subscriptable cannot be saved" do
      before do
        subscriptable = double
        object = User.new
        object.errors.add(:base, "Some error")
        errors = object.errors

        allow(subscriptable).to receive(:errors).and_return(errors)
        allow(subscriptable).to receive(:save).and_return(false)
        allow(subject).to receive(:subscriptable).and_return(subscriptable)
      end

      it_behaves_like "the service fails with error", "Some error"
    end

    context "when subscription already exists" do
      before do
        user.subscriptions.create!(subscriptable: twitter_user)
        allow(subject).to receive(:subscriptable).and_return(twitter_user)
      end

      it_behaves_like "the service fails with error", "subscription already exists"
    end

    context "when subscription cannot be save" do
      before do
        subscription = double
        object = User.new
        object.errors.add(:base, "Some error")
        errors = object.errors

        allow(subscription).to receive(:errors).and_return(errors)
        allow(subscription).to receive(:save).and_return(false)
        allow(subject).to receive(:subscriptable).and_return(twitter_user)
        allow(subject).to receive(:subscription).and_return(subscription)
      end

      it_behaves_like "the service fails with error", "Some error"
    end

    context "when everything works" do
      subject { described_class.new(user: user, input: input, subscriptable_class: Foo) }

      # stub the subscriptable_class
      # so sidekiq doesn't try to sync

      # rubocop:disable Lint/ConstantDefinitionInBlock
      # rubocop:disable Lint/EmptyClass
      class Foo
      end
      # rubocop:enable Lint/ConstantDefinitionInBlock
      # rubocop:enable Lint/EmptyClass

      class SyncFooJob # rubocop:disable Lint/ConstantDefinitionInBlock
        def self.perform_async(id); end
      end

      it "saves the subscription" do
        allow(subject).to receive(:subscriptable).and_return(twitter_user)
        expect { subject.call }.to change(user.subscriptions, :count).by(1)
        subscription = user.subscriptions.last
        expect(subscription.subscriptable).to eq twitter_user
      end

      it "kicks off a sync job" do
        subject = described_class.new(user: user, input: input, subscriptable_class: Foo)
        allow(subject).to receive(:subscriptable).and_return(twitter_user)
        expect(SyncFooJob).to receive(:perform_async)
        subject.call
      end
    end
  end
end
