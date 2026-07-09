require "rails_helper"

RSpec.describe SpreeAvailabilityNotifications::CreateAvailabilityNotificationService do
  describe ".call" do
    subject(:service_call) do
      described_class.call(
        email: email,
        variant_sku: variant_sku,
        variant_options: variant_options
      )
    end

    let(:email) { "customer@example.com" }
    let(:variant) { create(:variant, sku: "SKU-123") }
    let(:variant_sku) { variant.sku }
    let(:variant_options) { { "size" => "M", "color" => "Black" } }

    context "when variant exists" do
      it "creates an availability notification" do
        expect { service_call }
          .to change(SpreeAvailabilityNotifications::AvailabilityNotification, :count)
                .by(1)
      end

      it "returns the created availability notification" do
        expect(service_call).to be_a(SpreeAvailabilityNotifications::AvailabilityNotification)
        expect(service_call).to be_persisted
      end

      it "sets receiver email" do
        expect(service_call.receiver_email).to eq(email)
      end

      it "sets variant" do
        expect(service_call.variant).to eq(variant)
      end

      it "sets variant options" do
        expect(service_call.variant_options).to eq(variant_options)
      end
    end

    context "when variant_options are blank" do
      let(:variant_options) { nil }

      it "creates notification with empty variant options" do
        expect(service_call.variant_options).to eq({})
      end
    end

    context "when variant_options are an empty hash" do
      let(:variant_options) { {} }

      it "creates notification with empty variant options" do
        expect(service_call.variant_options).to eq({})
      end
    end

    context "when variant does not exist" do
      let(:variant_sku) { "MISSING-SKU" }

      it "raises a service error" do
        expect { service_call }
          .to raise_error(
                described_class::CreateAvailabilityNotificationServiceError,
                I18n.t(
                  "spree.availability_notifications.errors.variant_not_found",
                  sku: variant_sku
                )
              )
      end

      it "does not create an availability notification" do
        expect { service_call }
          .to raise_error(described_class::CreateAvailabilityNotificationServiceError)

        expect(SpreeAvailabilityNotifications::AvailabilityNotification.count).to eq(0)
      end
    end

    context "when availability notification is invalid" do
      let(:email) { "invalid-email" }

      it "raises ActiveRecord::RecordInvalid" do
        expect { service_call }
          .to raise_error(ActiveRecord::RecordInvalid)
      end

      it "does not create an availability notification" do
        expect { service_call }
          .to raise_error(ActiveRecord::RecordInvalid)

        expect(SpreeAvailabilityNotifications::AvailabilityNotification.count).to eq(0)
      end
    end
  end

  describe "#call" do
    subject(:service_call) do
      described_class.new(
        email: email,
        variant_sku: variant_sku,
        variant_options: variant_options
      ).call
    end

    let(:email) { "customer@example.com" }
    let(:variant) { create(:variant, sku: "SKU-456") }
    let(:variant_sku) { variant.sku }
    let(:variant_options) { { "size" => "L" } }

    it "creates an availability notification" do
      expect { service_call }
        .to change(SpreeAvailabilityNotifications::AvailabilityNotification, :count)
              .by(1)
    end
  end
end