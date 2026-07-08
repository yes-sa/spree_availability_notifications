module SpreeAvailabilityNotifications
  module Spree
    module VariantDecorator
      def self.prepended(base)
        base.has_many :availability_notifications,
                      class_name: "SpreeAvailabilityNotifications::AvailabilityNotification",
                      foreign_key: :variant_id,
                      dependent: :destroy
      end
    end
  end
end

if ::Spree::Variant.included_modules.exclude?(SpreeAvailabilityNotifications::Spree::VariantDecorator)
  ::Spree::Variant.prepend SpreeAvailabilityNotifications::Spree::VariantDecorator
end
