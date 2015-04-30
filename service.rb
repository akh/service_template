require "bundler/setup"
require 'goliath'
require 'yajl'
require 'grape'
require "mongoid"
require 'logger'

env_map = {
	'prod' => 'production',
	'dev'  => 'development',
	'test' => 'test'
}

goliath_env = ARGV[1]

mongo_env = env_map[goliath_env]
raise "Invalid goliath env #{goliath_env}, should be one of #{env_map.keys}" if mongo_env.nil?
Mongoid.load!(File.expand_path('config/mongoid.yml', __dir__), mongo_env)


root_dir = File.expand_path('..', __FILE__)
require File.join(root_dir, 'script/infra.rb')
app_dir = File.join(root_dir, 'app')
require_dir File.join(app_dir, 'helpers')
require_dir File.join(app_dir, 'apis')
require_dir File.join(app_dir, 'models')

class Application < Goliath::API
  def response(env)
    ::AllAPI.call(env)
  end
end

