require 'logger'
require 'grape'
require 'factory_girl'
require "rack/test"
require 'mongoid'
require 'mongoid-rspec'

spec_dir = __dir__
Dir[File.join(spec_dir, "support/**/*.rb")].each {|f| require f}
Dir[File.join(spec_dir, "helpers/**/*.rb")].each {|f| require f}

Mongoid.load!(File.expand_path('../config/mongoid.yml', spec_dir), 'test')

require File.expand_path('../script/infra', spec_dir)
models_dir = File.expand_path("../app/models", spec_dir)
require_dir models_dir
helpers_dir = File.expand_path("../app/helpers", spec_dir)
require_dir helpers_dir
apis_dir = File.expand_path("../app/apis", spec_dir)
require_dir apis_dir

FactoryGirl.find_definitions

RSpec.configure do |config|
  config.mock_with :rspec

  config.include FactoryGirl::Syntax::Methods

  config.include(CustomizedMatchers)

  config.before(:each) do
    clear_db
  end
end

def debug(message)
  logger = Logger.new(STDOUT)
  logger.info "=============Start debug=================\n"
  logger.info "#{message}\n"
  logger.info "=============End debug=================\n"
end

def error_msg
  JSON.parse(last_response.body)["error"]
end

def resp
  last_response
end

def resp_body
  JSON.parse(last_response.body)
end

class String
  SERVICE_API_VERSION = ENV["SERVICE_API_VERSION"] ? ENV["SERVICE_API_VERSION"] : 'v1'
  def with_version
    "/#{SERVICE_API_VERSION}#{self}"
  end
end

class Array
  def should_have!(content)
    raise "error" unless self.include?(content)
  end
end

def show_error(model)
  debug model.errors.full_messages
end

def assert_field_is_invalid(model, field, message = "is invalid")
  model.should_not be_valid
  model.errors.messages[field].include?(message).should be_true
end

def assert_field_is_not_a_number(model, field, message = "is not a number")
  model.should_not be_valid
  model.errors.messages[field].include?(message).should be_true
end

def assert_field_cannot_be_blank(model, field, message = "can't be blank")
  model.should_not be_valid
  model.errors.messages[field].include?(message).should be_true
end
