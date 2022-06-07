require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../dummy/config/environment.rb', __FILE__)

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'pry-byebug'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  include ActiveRecordDiscover
  include ModelHelper, DummyConstantHelper

  config.after :suite do
    ModelTemplate.clean
    ConcernTemplate.clean
  end
end

