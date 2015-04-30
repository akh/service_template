require 'ostruct'

class String
  def append(item)
    File.join(self, item)
  end
end

$fs = OpenStruct.new
$fs.root = File.expand_path('..', __FILE__)
$fs.script = $fs.root.append 'script'
$fs.build = $fs.script.append 'build'
$fs.templates = $fs.script.append 'templates'

$fs.db = $fs.root.append 'db'
$fs.migrate = $fs.db.append 'migrate'

$fs.app = $fs.root.append 'app'
$fs.models = $fs.app.append 'models'

$fs.config = $fs.root.append 'config'
$fs.db_config = $fs.config.append 'database.yml'

$db = OpenStruct.new
$db.root = 'root'

require $fs.script.append 'infra.rb'
require_dir $fs.script.append 'build'
