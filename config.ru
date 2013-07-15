ENV['RACK_ENV'] ||= 'development'

require 'rubygems'
require 'bundler/setup'
require File.expand_path(File.join(File.dirname(__FILE__), 'server'))


if ENV['RACK_ENV'] == 'development'
  require 'dotenv'
  Dotenv.load
end

use Rack::Session::Cookie, secret: 'foo', path: '/'
use OmniAuth::Builder do
  provider :heroku, ENV['HEROKU_OAUTH_ID'], ENV['HEROKU_OAUTH_SECRET']
end

static_app = Rack::Builder.new do
  use Rack::Static, :urls => [''], :root => 'public', :index => 'index.html'
  run Rack::File.new('public')
end

run Rack::Cascade.new([static_app, G5::HerokuDynoStatusBoard])