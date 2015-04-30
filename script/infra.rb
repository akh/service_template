require 'fileutils'
require 'erb'
require 'logger'

module Build
  class Config
    def initialize
      @config = {}
    end

    def each_pair(&block)
      raise "Should call with a block" unless block_given?
      @config.each_pair do |key, value|
        block.call(key, value)
      end
    end

    def to_s
      @config.collect { |pair| "#{pair.first} => #{pair.last}" }.join("\n")
    end

    def get_binding
      @config.each_pair do |key, value|
        instance_variable_set "@#{key}", value
      end
      binding
    end

    def [](key)
      key = key.to_sym unless key.is_a? Symbol
      raise "Unknown configuration item #{key}" unless @config.has_key? key
      @config[key]
    end

    def []=(key, value)
      key = key.to_sym unless key.is_a? Symbol
      @config[key] = value
    end

    private

    def log(message)
      @logger ||= Logger.new(STDOUT)
      @logger.info message
    end

    def method_missing(method, *args, &block)
      raise "Unknown configuration item: #{method}" unless @config.has_key?(method)
      @config[method]
    end
  end
end

def render_template(template_file, output_file, config)
  output = ERB.new(IO.readlines(template_file).join).result(config.get_binding)
  File.open(output_file, 'w') { |file| file.write(output) }
end

def info(message)
  Logger.new(STDOUT).info ">>>>> #{message}\n"
end

def run(command)
  info "Will run command #{command}"
  abort "Failed to run command => #{command}" unless system command
end

def clean_dir(dir)
  FileUtils.rm_rf dir if File.directory? dir
  FileUtils.mkdir_p dir
end

def require_dir(dir)
  Dir.foreach(dir) do |entry|
    absolute_path = File.join(dir, entry)
    next if (entry == "." || entry == "..")
    require absolute_path if (File.file?(absolute_path) && absolute_path.end_with?("rb"))
    require_dir(absolute_path) if File.directory?(absolute_path)
  end
end
