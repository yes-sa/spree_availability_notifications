import '@hotwired/turbo-rails'
import { Application } from '@hotwired/stimulus'

let application

if (typeof window.Stimulus === "undefined") {
  application = Application.start()
  application.debug = false
  window.Stimulus = application
} else {
  application = window.Stimulus
}

import SpreeAvailabilityNotificationsController from 'spree_availability_notifications/controllers/spree_availability_notifications_controller' 

application.register('spree_availability_notifications', SpreeAvailabilityNotificationsController)