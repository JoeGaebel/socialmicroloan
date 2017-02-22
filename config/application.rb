require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SocialMicroloan
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.generators do |g|
      g.test_framework :rspec
    end

    config.action_view.embed_authenticity_token_in_remote_forms = true

    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '/connect/confirm', :headers => :any, :methods => [:get, :post]
      end
    end
  end
end
