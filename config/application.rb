require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CfkFinder
  class Application < Rails::Application
    I18n.load_path << "#{Gem.loaded_specs['date_validator'].full_gem_path}/locales/en.yml"
  end
end
