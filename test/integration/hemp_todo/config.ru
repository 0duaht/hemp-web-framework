require "hemp"
RACK_ROOT = __dir__
$LOAD_PATH.unshift File.expand_path(RACK_ROOT)

require_relative "config/application"

TodoApplication = HempTodo::Application.new
require_relative "config/routes.rb"

Hemp::Dependencies.load_files

use Rack::Static, urls: ["/css", "/images"], root: "app/assets"
use Rack::MethodOverride
run TodoApplication
