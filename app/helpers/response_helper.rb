module ResponseHelpers
  class ErrorMap
    def initialize
      default_error_file = File.expand_path("../../../config/error_mapping.yml", __FILE__)
      error_map_file = ENV["ERROR_MAPPING_FILE"] || default_error_file
      @errors = YAML.load(File.read(error_map_file))['errors']
    end

    def method_missing(method, *args, &block)
      error_code = method.to_s.upcase
      super unless @errors.keys.include?(error_code)
      {
          "error_code" => error_code,
          "error_message" => @errors[error_code]
      }
    end
  end

  def created_successfully(model)
    {
        status: 201,
        data: model
    }
  end

  def found_successfully(model)
    {
        status: 200,
        data: model
    }
  end

  def created_failed(model)
    internal_server_error! model.errors.full_messages
  end

  def not_found!
    error!("Not found", 404)
  end

  def bad_request!
    error!("Bad request", 400)
  end

  def internal_server_error!(message = nil)
    error!(message ? message : "Internal server error", 500)
  end

  def unauthorized!(message = nil)
    error!(message ? message : "Unauthorized", 401)
  end

  def error_map
    @error_mapping ||= ErrorMap.new
  end

  def map_error(error, mapping)
    matched_error = mapping.select { |key| key == error }.first
    if matched_error
      error_map.send matched_error.last
    else
      logger = Logger.new(STDERR)
      logger.error("Unknown error happened: #{error}")
      error_map.send :e0
    end
  end
end

module CommonModelError
  CANNOT_BE_BLANK = "can't be blank"
  IS_INVALID = "is invalid"
  IS_NOT_A_NUMBER = "is not a number"
  HAS_ALREADY_BEEN_TAKEN = "has already been taken"
  DOES_NOT_MATCH_CONFIRMATION = "doesn't match confirmation"
end
