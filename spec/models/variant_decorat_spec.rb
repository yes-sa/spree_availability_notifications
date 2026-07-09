require "rails_helper"

RSpec.describe Spree::Variant, type: :model do
  describe "availability notifications association" do
    let(:variant) { create(:variant) }
    let(:receiver_email) { "john@doe.com" }

    it "has many availability notifications" do
      association = described_class.reflect_on_association(:availability_notifications)

      expect(association).to be_present
      expect(association.macro).to eq(:has_many)
    end

    it "uses the availability notification class" do
      association = described_class.reflect_on_association(:availability_notifications)

      expect(association.class_name).to eq(
                                          "SpreeAvailabilityNotifications::AvailabilityNotification"
                                        )
    end

    it "uses variant_id as the foreign key" do
      association = described_class.reflect_on_association(:availability_notifications)

      expect(association.foreign_key).to eq("variant_id")
    end

    it "destroys dependent availability notifications" do
      association = described_class.reflect_on_association(:availability_notifications)

      expect(association.options[:dependent]).to eq(:destroy)
    end

    it "returns related availability notifications" do
      availability_notification = SpreeAvailabilityNotifications::AvailabilityNotification.create!(
        receiver_email: receiver_email,
        variant: variant
      )

      expect(variant.availability_notifications).to contain_exactly(
                                                      availability_notification
                                                    )
    end

    it "destroys related availability notifications when variant is destroyed" do
      SpreeAvailabilityNotifications::AvailabilityNotification.create!(
        receiver_email: receiver_email,
        variant: variant
      )

      expect { variant.destroy }
        .to change(
              SpreeAvailabilityNotifications::AvailabilityNotification,
              :count
            ).by(-1)
    end
  end
end