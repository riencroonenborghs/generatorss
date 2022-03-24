require "rails_helper"

RSpec.describe Discord::Api::Client, type: :service do
  describe "#get" do
    subject { described_class.new }
    before { allow(described_class).to receive(:get).and_return(response) }

    context "when the response was a success" do
      let(:response) { double({ success?: true, body: { data: "data" }.to_json }) }

      it "succeeds" do
        subject.get("some url")
        expect(subject.success?).to be_truthy
      end

      it "returns data" do
        expect(subject.get("some url")).to eq({ "data" => "data" })
      end
    end

    context "when the response was a failure" do
      let(:response) { double({ success?: false, body: { message: "error" }.to_json }) }

      it "fails" do
        subject.get("some url")
        expect(subject.failure?).to be_truthy
      end

      it "sets the error" do
        subject.get("some url")
        expect(subject.errors.full_messages).to include("error")
      end
    end
  end
end
