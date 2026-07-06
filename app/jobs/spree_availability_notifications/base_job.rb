module SpreeAvailabilityNotifications
  class BaseJob < Spree::BaseJob
    queue_as SpreeAvailabilityNotifications.queue
  end
end
