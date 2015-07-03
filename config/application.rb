require File.expand_path('../boot', __FILE__)

require 'rails/all'
require ''

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mxing
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.active_record.raise_in_transactional_callbacks = true
    config.middleware.insert_after ActionDispatch::ParamsParser, ActionDispatch::XmlParamsParser

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'zh-CN'
    config.active_job.queue_adapter = :sidekiq

    # config.log_level = :info
    # config.logger = ActFluentLoggerRails::Logger.new('', shift_age = 'daily')
    # config.lograge.enabled = true
    # config.lograge.formatter = Lograge::Formatters::Json.new
  end
end
