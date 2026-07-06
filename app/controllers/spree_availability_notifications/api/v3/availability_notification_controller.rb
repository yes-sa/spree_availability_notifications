# frozen_string_literal: true

module SpreeAvailabilityNotifications
  module Api
    module V3
        class AvailabilityNotificationController < ::Spree::Api::V3::Store::BaseController
          def create

            return :ok
          end

          private

          def availability_notification_params
            params.require(:availability_notification).permit(
              :email,
              variant: [
                :sku,
                { options: {} }
              ]
            )
          end
        end
    end
  end
end
