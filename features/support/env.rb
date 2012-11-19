PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../../config/boot")

require 'capybara/cucumber'
require 'rspec/expectations'

##
# You can handle all padrino applications using instead:
#   Padrino.application
Capybara.app = Planner.tap { |app|  }

DatabaseCleaner.strategy = :truncation

Before do
  DatabaseCleaner.start
end

After do
  DatabaseCleaner.clean
end

def cookie_jar
  Capybara.current_session.driver.browser.current_session.instance_variable_get(:@rack_mock_session).cookie_jar
end
