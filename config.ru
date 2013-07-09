ENV['RACK_ENV'] ||= 'development'
require "rubygems"
require "bundler/setup"

require File.expand_path(File.join(File.dirname(__FILE__), 'server'))
# Adds SSL for testing OmniAuth locally
if ENV['RACK_ENV'] == 'development'
  require 'dotenv'

  Dotenv.load

  G5::HerokuDynoStatusBoard.run! do |server|
    ssl_options = {
      :cert_chain_file => ENV['CERT_CHAIN_FILE'],
      :private_key_file => ENV['PRIVATE_KEY_FILE'],
      :verify_peer => false
    }
    server.ssl = true
    server.ssl_options = ssl_options
  end
else
  run G5::HerokuDynoStatusBoard
end