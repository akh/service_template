module CustomizedMatchers
  class ResponseError
    def initialize(pattern, error_code = nil)
      @error_code = error_code
      @pattern = pattern
    end

    def matches?(target)
      @raw_errors = JSON.parse(target.body)["error"]
      if @error_code
        @error_codes = @raw_errors.map { |error| error["error_code"] }
        @error_messages = @raw_errors.map { |error| error["error_message"] }.join('\n')
        @error_codes.include?(@error_code) && @error_messages =~ @pattern
      else
        @error_messages = @raw_errors
        @error_messages =~ @pattern
      end
    end

    def failure_message
      "expect response has error matches #{@error_code}: #{@pattern.inspect} \nactual got #{@raw_errors}"
    end

    def failure_message_when_negated
      failure_message
    end
  end

  def have_error(code, message)
    ResponseError.new(Regexp.new(message), code)
  end

  def have_error_message(message)
    ResponseError.new(Regexp.new(message))
  end

end