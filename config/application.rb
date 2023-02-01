require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Lcyc
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.active_job.queue_adapter = :delayed_job

    config.time_zone = "Eastern Time (US & Canada)"

    config.after_initialize do
      config.action_view.sanitized_allowed_tags = Rails::Html::SafeListSanitizer.allowed_tags.add("u")
    end
  end
end
