# app/services/spree_availability_notifications/create_availability_notification.rb
# frozen_string_literal: true

module SpreeAvailabilityNotifications
  class CreateAvailabilityNotificationService
    class CreateAvailabilityNotificationServiceError < StandardError; end

    def self.call(...)
      new(...).call
    end

    def initialize(email:, variant_sku:, variant_options: {})
      @email = email
      @variant_sku = variant_sku
      @variant_options = variant_options.presence || {}
    end

    def call
      AvailabilityNotification.create!(
        receiver_email: email,
        variant: variant,
        variant_options: variant_options
      )
    end

    private

    attr_reader :email, :variant_sku, :variant_options

    def variant
      @variant ||= ::Spree::Variant.find_by(sku: variant_sku)

      return @variant if @variant

      raise CreateAvailabilityNotificationServiceError,
            I18n.t(
              'spree.availability_notifications.errors.variant_not_found'
            ),
            sku: @variant_sku
    end
  end
end