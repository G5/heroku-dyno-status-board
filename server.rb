require 'thin'
require 'grape'
require 'grape-rabl'
require 'omniauth'
require 'omniauth-heroku'
require 'heroku-api'
require 'pry'

module G5
  class HerokuDynoStatusBoard < Grape::API

    format :json

    get '/auth/:name/callback' do
      cookies[:auth] = {
        path: '/'
      }
      cookies[:auth][:value] = request.env['omniauth.auth']['credentials']['token']

      # Test Apps For Mock
      # heroku = Heroku::API.new(:api_key => access_token, :mock => true)
      # heroku.post_app(:name => 'my-test-app')
      # heroku.post_app(:name => 'my-test-app2')
      200
    end

    namespace :heroku do
      get :apps do

        heroku = Heroku::API.new(:api_key => cookies[:auth])
        heroku.get_apps.body
      end
    end

    # get '/user' do
    #   @user = { :user => session['heroku_api'].get_user.body }
    #   @user.to_json
    # end

    # get '/heroku_apps/:name' do
    #   @app = { :heroku_app => session['heroku_api'].get_app(params[:name]).body }
    #   binding.pry
    #   @app.to_json
    # end

    # post '/heroku_apps/:name' do
    #   # Support only for cedar currently
    #   session['heroku_api'].post_ps_scale(params[:name], 'worker', '1')
    # end

  end
end
