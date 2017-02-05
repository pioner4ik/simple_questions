require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
# Load defaults from config/*.env in config
Dotenv.load *Dir.glob(Rails.root.join("config/**/*.env"), File::FNM_DOTMATCH)

# Override any existing variables if an environment-specific file exists
Dotenv.overload *Dir.glob(Rails.root.join("config/**/*.env.#{Rails.env}"), File::FNM_DOTMATCH)


module SimpleQuestions
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    config.active_job.queue_adapter = :sidekiq
    
    config.responders.flash_keys = [ :success, :warning, :danger ]

    config.action_cable.disable_request_forgery_protection = false
    
    config.generators do |q|
      q.test_framework :rspec,
                       fixtures: true,
                       view_spec: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false,
                       controller_specs: true
      q.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
