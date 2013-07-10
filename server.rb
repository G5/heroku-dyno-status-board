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
      send_file File.expand_path('index.html', settings.public_folder)
    end

    get '/sign_in' do
      redirect '/auth/heroku'
    end

    get '/auth/:name/callback' do
      auth = request.env['omniauth.auth']
      access_token = auth['credentials']['token']
      session['access_token'] = access_token

      redirect '/#/heroku_apps'
    end

    get '/heroku_apps' do
      heroku_api = Heroku::API.new(:api_key => session['access_token'])
      @apps = { :heroku_apps => heroku_api.get_apps.body }

      @apps.to_json
    end

  end
end
