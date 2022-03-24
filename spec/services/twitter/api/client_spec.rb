require "rails_helper"

RSpec.describe Twitter::Api::Client, type: :service do
  subject { described_class.new }

  describe "#parse" do
    context "when the response was a success" do
      let(:response) { double({ success?: true, body: data }) }

      context "when the response has data" do
        let(:data) { { data: "data" }.to_json }

        it "succeeds" do
          subject.parse(response)
          expect(subject).to be_success
        end

        it "returns data" do
          expect(subject.parse(response)).to eq "data"
        end
      end

      context "when the response has errors" do
        let(:data) { { errors: [{ message: "message" }] }.to_json }

        it "fails" do
          subject.parse(response)
          expect(subject).to_not be_success
        end

        it "sets errors" do
          subject.parse(response)
          expect(subject.errors.full_messages).to include "message"
        end
      end
    end

    context "when there's regular errors" do
      let(:response) { "" }

      it "fails" do
        subject.parse(response)
        expect(subject).to_not be_success
      end

      it "sets errors" do
        subject.parse(response)
        expect(subject.errors.full_messages).to_not be_empty
      end
    end
  end
end
