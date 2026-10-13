module SpreeAvailabilityNotifications
  class AvailabilityNotification < ::Spree.base_class
    EMAIL_REGEXP = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/
    belongs_to :variant, class_name: 'Spree::Variant'

    scope :not_synced, -> { where(synced_at: nil) }

    validates :variant, presence: true
    validates :receiver_email,
              presence: true,
              format: {
                with: EMAIL_REGEXP,
                message: I18n.t('spree.availability_notifications.errors.invalid_email')
              }

    # Define if any sync with an outer system is needed
    def sync_notification
      return unless defined?(SyncNotificationsJob)

      SyncNotificationsJob.perform_async(id)
    end
  end
end
