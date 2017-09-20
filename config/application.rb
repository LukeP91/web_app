require_relative 'boot'

require 'csv'
require File.expand_path('../boot', __FILE__)
ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WebApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.action_controller.perform_caching = true
    config.cache_store = :redis_store, "redis://localhost:6379/0/cache", { expires_in: 90.minutes }
    config.action_cable.mount_path = '/websocket'
  end
end
