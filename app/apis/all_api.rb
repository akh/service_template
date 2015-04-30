apis = %w(media_api)
apis.each { |api| require File.expand_path("../#{api}", __FILE__) }

# %w(rest-client).each { |gem| require gem }

class AllAPI < Grape::API
  version 'v1', :using => :path
  format :json

  # rescue_from RestClient::ResourceNotFound do |e|
  #   logger = Grape::API.logger
  #   logger.error e.message
  #   logger.error e.backtrace
  #   Rack::Response.new([ "#{e.message}" ], 404)
  # end

  rescue_from :all do |e|
    logger = Grape::API.logger
    logger.error e.message
    logger.error e.backtrace
    error = {
      :error => [{:error_code => 'E0', :error_message => "未知的错误"}]
    }
    Rack::Response.new([error.to_json], 500, {"Content-type" => "application/json"}).finish
  end

  helpers LogHelpers
  helpers ResponseHelpers

  mount MediaAPI
end