# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_availability_notifications/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_availability_notifications'
  s.version     = SpreeAvailabilityNotifications::VERSION
  s.summary     = "Spree Commerce Availability notifications Extension"
  s.required_ruby_version = '>= 3.2'

  s.author    = 'Tomasz Strzeszewski'
  s.email     = 'tomasz.strzeszewski@yes.pl'
  s.homepage  = 'https://github.com/spree_availability_notifications'
  s.license   = 'MIT'

  s.files        = Dir["{app,config,db,lib,vendor}/**/*", "LICENSE.md", "Rakefile", "README.md"].reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = 'lib'
  s.requirements << 'none'

  spree_version = '< 6.0'
  s.add_dependency 'spree', spree_version
  s.add_dependency 'spree_admin', spree_version

  s.add_development_dependency 'spree_dev_tools'
end
