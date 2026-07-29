module Spree
  module Admin
    class AvailabilityNotificationsController < BaseController
      def index
        @selected_range = params[:range].presence || "all"
        @date_from, @date_to = selected_date_range

        @availability_notifications =
          dated_scope
            .joins(:variant)
            .select(
              :variant_id,
              :variant_options,
              "spree_variants.sku AS variant_sku",
              "COUNT(*) AS notifications_count",
              "MAX(availability_notifications.created_at) AS last_created_at"
            )
            .group(
              :variant_id,
              :variant_options,
              "spree_variants.sku"
            )
            .order(Arel.sql("last_created_at DESC"))
      end

      def show
        @variant = Spree::Variant.find(params[:id])
        @variant_options = JSON.parse(params.require(:variant_options))

        @availability_notifications =
          @variant
            .availability_notifications
            .where(variant_options: @variant_options)
            .order(created_at: :desc)
      rescue JSON::ParserError, ActionController::ParameterMissing
        redirect_to(
          spree.admin_availability_notifications_path,
          alert: "Invalid variant options"
        )
      end

      private

      def selected_date_range
        case params[:range]
        when 'day'
          [1.day.ago.beginning_of_day, Time.current.end_of_day]
        when "week"
          [1.week.ago.beginning_of_day, Time.current.end_of_day]
        when "month"
          [1.month.ago.beginning_of_day, Time.current.end_of_day]
        when "custom"
          custom_date_range
        else
          [nil, nil]
        end
      end

      def dated_scope
        if  @date_from && @date_to
          SpreeAvailabilityNotifications::AvailabilityNotification.where(created_at: @date_from..@date_to)
        else
          SpreeAvailabilityNotifications::AvailabilityNotification
        end
      end

      def custom_date_range
        from = parse_date(params[:from]) || Time.zone.today
        to   = parse_date(params[:to]) || from

        [from.beginning_of_day, to.end_of_day]
      end

      def parse_date(value)
        return if value.blank?

        Time.zone.parse(value)
      rescue ArgumentError, TypeError
        nil
      end
    end
  end
end