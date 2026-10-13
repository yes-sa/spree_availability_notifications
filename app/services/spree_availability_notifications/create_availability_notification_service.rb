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
      @variant_options = normalize_options(variant_options)
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

    # Options may come straight from the controller as ActionController::Parameters
    def normalize_options(options)
      options = options.to_h if options.respond_to?(:to_h)

      options.presence || {}
    end

    def variant
      @variant = find_variant unless defined?(@variant)

      return @variant if @variant

      raise CreateAvailabilityNotificationServiceError,
            I18n.t(
              'spree.availability_notifications.errors.variant_not_found',
              sku: variant_sku
            )
    end

    def find_variant
      scope = variant_options.reduce(::Spree::Variant.where(sku: variant_sku)) do |variants, (type, value)|
        variants.where(id: variants_with_option(type, value))
      end

      scope.first
    end
    
    def variants_with_option(type, value)
      ::Spree::Variant
        .joins(option_values: :option_type)
        .where('LOWER(spree_option_types.name) = :type', type: type.to_s.downcase)
        .where(
          'LOWER(spree_option_values.name) = :value ' \
          'OR LOWER(spree_option_values.presentation) = :value',
          value: value.to_s.downcase
        )
        .select(:id)
    end
  end
end
