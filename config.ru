require "bundler/setup"

Bundler.require(:default, ENV.fetch("RACK_ENV", "development"))

require_relative "lib/app"

use Rack::CommonLogger
use Rack::ContentLength
use Rack::ContentType, "text/plain"
use Rack::Runtime

run App
