# spec/models/spree_availability_notifications/availability_notification_spec.rb

require "rails_helper"

RSpec.describe SpreeAvailabilityNotifications::AvailabilityNotification, type: :model do
  subject(:availability_notification) do
    described_class.new(
      receiver_email: receiver_email,
      variant: variant
    )
  end

  let(:receiver_email) { "customer@example.com" }
  let(:variant) { create(:variant) }

  describe "associations" do
    it "belongs to a Spree variant" do
      expect(availability_notification.variant).to eq(variant)
    end
  end

  describe "validations" do
    context "with valid attributes" do
      it "is valid" do
        expect(availability_notification).to be_valid
      end
    end

    describe "receiver_email" do
      context "when present and valid" do
        let(:receiver_email) { "customer@example.com" }

        it "is valid" do
          expect(availability_notification).to be_valid
        end
      end

      context "when missing" do
        let(:receiver_email) { nil }

        it "is not valid" do
          expect(availability_notification).not_to be_valid
          expect(availability_notification.errors[:receiver_email]).to include("can't be blank")
        end
      end

      context "when blank" do
        let(:receiver_email) { "" }

        it "is not valid" do
          expect(availability_notification).not_to be_valid
          expect(availability_notification.errors[:receiver_email]).to include("can't be blank")
        end
      end

      invalid_emails = [
        "plainaddress",
        "missing-at-sign.com",
        "missing-domain@",
        "@missing-local.com",
        "has spaces@example.com",
        "customer@example",
        "customer@.com"
      ]

      invalid_emails.each do |email|
        context "when email is #{email.inspect}" do
          let(:receiver_email) { email }

          it "is not valid" do
            expect(availability_notification).not_to be_valid
            expect(availability_notification.errors[:receiver_email]).to include(
                                                                           "is not a valid email address"
                                                                         )
          end
        end
      end

      valid_emails = [
        "customer@example.com",
        "customer.name@example.com",
        "customer+tag@example.com",
        "customer_name@example.co.uk"
      ]

      valid_emails.each do |email|
        context "when email is #{email.inspect}" do
          let(:receiver_email) { email }

          it "is valid" do
            expect(availability_notification).to be_valid
          end
        end
      end
    end

    describe "variant" do
      context "when missing" do
        let(:variant) { nil }

        it "is not valid" do
          expect(availability_notification).not_to be_valid
          expect(availability_notification.errors[:variant]).to include("can't be blank")
        end
      end
    end
  end
end