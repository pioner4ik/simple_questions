require 'rails_helper'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist
Capybara.server = :puma 
#Capybara.default_max_wait_time = 10

RSpec.configure do |config|
  config.include AcceptanceMacros, type: :feature
end