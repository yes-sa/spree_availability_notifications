# frozen_string_literal: true

module Spree
  module Api
    module V3
      class AvailabilityNotificationsController < ::Spree::Api::V3::BaseController
        def create
          create_notification

          head :no_content
        rescue ::SpreeAvailabilityNotifications::CreateAvailabilityNotificationService::CreateAvailabilityNotificationServiceError => e
          capture_exception(e)
          render json: {
            errors: [
              {
                code: "variant_not_found",
                message: e.message,
                variant_sku: e.sku
              }
            ]
          }, status: :unprocessable_entity
        rescue ::ActiveRecord::RecordInvalid => e
          capture_exception(e)
          render json: { errors: e.record.errors.to_hash },
                 status: :unprocessable_entity
        end

        private

        def create_notification
          ::SpreeAvailabilityNotifications::CreateAvailabilityNotificationService.call(
            email: availability_notification_params[:email],
            variant_sku: availability_notification_params.dig(:variant, :sku),
            variant_options: availability_notification_params.dig(:variant, :options)
          )
        end

        def availability_notification_params
          params.require(:availability_notification).permit(
            :email,
            variant: [
              :sku,
              { options: {} }
            ]
          )
        end

        def capture_exception(e)
          return unless defined?(Sentry)

          Sentry.capture_exception(e,
                                   level: 'error',
                                   tags: { component: 'availability_notification', category: 'create_notification' },
                                   extra: { message: e.message, params: availability_notification_params })
        end
      end
    end
  end
end