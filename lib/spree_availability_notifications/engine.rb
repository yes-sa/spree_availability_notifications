module SpreeAvailabilityNotifications
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_availability_notifications'

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree_availability_notifications.environment', before: :load_config_initializers do |_app|
      SpreeAvailabilityNotifications::Config = SpreeAvailabilityNotifications::Configuration.new
    end

    initializer 'spree_availability_notifications.assets' do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.paths << root.join('app/javascript')
        app.config.assets.precompile += %w[spree_availability_notifications_manifest]
      end
    end

    initializer 'spree_availability_notifications.importmap', before: 'importmap' do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join('config/importmap.rb')
        # https://github.com/rails/importmap-rails?tab=readme-ov-file#sweeping-the-cache-in-development-and-test
        app.config.importmap.cache_sweepers << root.join('app/javascript')
      end
    end
  end
end
