source 'https://rubygems.org'

gem 'rails-controller-testing'
gem 'rails', '~> 8.0.0'
spree_opts = '< 6.0'
gem 'spree', spree_opts
gem 'spree_admin', spree_opts

gem 'spree_dev_tools', '>= 0.6.0.rc1'

if ENV['DB'] == 'mysql'
  gem 'mysql2'
elsif ENV['DB'] == 'postgres'
  gem 'pg'
else
  gem 'sqlite3'
end

group :development, :test do
  gem "debug", platforms: %i[mri windows]
end

group :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "database_cleaner-active_record"
  gem 'webmock'
end

gem 'propshaft'

gemspec
