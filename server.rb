require 'thin'
require 'grape'
require 'omniauth'
require 'omniauth-heroku'
require 'json'
require 'heroku-api'

module G5
  class HerokuDynoStatusBoard < Grape::API
    format :json

    get '/auth/:name/callback' do
      cookies[:auth] = { path: '/' }
      cookies[:auth][:value] = request.env['omniauth.auth']['credentials']['token']

      redirect '/#/apps'
    end

    get :logout do
      cookies.delete :auth
      redirect '/'
    end

    namespace :heroku do
      before do
         @heroku = Heroku::API.new(:api_key => cookies[:auth])
      end

      resources :apps do
        desc 'Get all apps'
        get do
          { apps: @heroku.get_apps.body }
        end

        desc 'Operations on a single application'
        params do
          requires :id, type: Integer, desc: 'Heroku App ID'
        end
        route_param :id do
          desc 'Get application by id'
          get do
            @name = @heroku.get_apps.body.detect{|app| app["id"] == params[:id]}["name"]
            { app: @heroku.get_app(@name).body }
          end

          desc 'Update dyno count by id'
          put do
            @name = @heroku.get_apps.body.detect{|app| app["id"] == params[:id]}["name"]
            @heroku.post_ps_scale(@name, 'web', params[:app][:dynos])

            { app: @heroku.get_app(@name).body }
          end
        end
      end
    end
  end
end
