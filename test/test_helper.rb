ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def api_sign_in(role)
    @request.headers["X-Entity-Token"] = role.user.authentication_token
    @request.headers["X-Entity-Email"] = role.user.email
  end

  def json_has_keys(json, *keys)
    keys.each do |key|
      assert json.has_key?(key.to_s), "JSON did not have #{key.to_s} key"
    end
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end
