Pod::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false
  # Below added for simplecov:
  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files = true

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Opt-in to next version's behavior
  config.active_record.raise_in_transactional_callbacks = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # this is a browser cache buster of css and js assets
  config.assets.digest = true

  # this sets up log rotating first arg the log file location, second arg the number of files to rotate through
  # third arg the size of each file
  config.logger = Logger.new("#{Rails.root}/log/#{Rails.env}.log", 10, 10.megabytes)

  config.active_job.queue_adapter = :async
end
