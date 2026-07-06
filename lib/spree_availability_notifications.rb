require 'spree'
require 'spree_availability_notifications/engine'
require 'spree_availability_notifications/version'
require 'spree_availability_notifications/configuration'

module SpreeAvailabilityNotifications
  mattr_accessor :queue

  def self.queue
    @@queue ||= Spree.queues.default
  end
end
