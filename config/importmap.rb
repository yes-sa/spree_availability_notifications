pin 'application-spree-availability-notifications', to: 'spree_availability_notifications/application.js', preload: false

pin_all_from SpreeAvailabilityNotifications::Engine.root.join('app/javascript/spree_availability_notifications/controllers'),
             under: 'spree_availability_notifications/controllers',
             to:    'spree_availability_notifications/controllers',
             preload: 'application-spree-availability-notifications'
