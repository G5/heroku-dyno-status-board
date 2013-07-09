require 'thin'
require 'sinatra'
require 'omniauth'
require 'omniauth-heroku'
require 'heroku-api'

module G5
  class HerokuDynoStatusBoard < Sinatra::Base

    configure do
      enable :sessions
    end

    use OmniAuth::Builder do
      provider :heroku, ENV['HEROKU_OAUTH_ID'], ENV['HEROKU_OAUTH_SECRET']
    end


    get '/' do
      '<a href="/sign_in">Sign in with Heroku</a>'
    end

    get '/sign_in' do
      redirect '/auth/heroku'
    end

    get '/auth/:name/callback' do
      auth = request.env['omniauth.auth']
      access_token = request.env['omniauth.auth']['credentials']['token']
      heroku_api = Heroku::API.new(:api_key => access_token)
      @apps = heroku_api.get_apps.body

      puts @apps

      redirect '/'
    end

  end
end
