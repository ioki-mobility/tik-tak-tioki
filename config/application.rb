require_relative "boot"

require "rails"

# This list is here as documentation only - it's not used
# see https://github.com/rails/rails/blob/7-0-stable/railties/lib/rails/all.rb
omitted = %w(
  active_storage/engine
  action_mailer/railtie
  action_cable/engine
  action_mailbox/engine
  action_text/engine
  rails/test_unit/railtie
  active_job/railtie
)

%w(
  active_record/railtie
  action_controller/railtie
  action_view/railtie
).each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TikTakTioki
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("app/services")
    config.autoload_paths << Rails.root.join("app/services")
  end
end
