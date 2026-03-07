require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f

    # For compatibility with applications that use this config
    config.action_controller.include_all_helpers = false

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")


    # Load Lesli migrations
    initializer :load_external_engine_migrations do |app|
        engine_b_spec = Gem::Specification.find_by_name("lesli")
        engine_b_migration_path = File.join(engine_b_spec.gem_dir, "db", "migrate")

        if Dir.exist?(engine_b_migration_path)
            app.config.paths["db/migrate"] << engine_b_migration_path
        end
    rescue Gem::LoadError
        puts "Lesli engine not found; skipping migration autoload."
    end
  end
end
