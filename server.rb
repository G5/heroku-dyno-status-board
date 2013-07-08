require 'sinatra'

module G5
  class HerokuDynoStatusBoard < Sinatra::Base

    get '/' do
      "Hello World"
    end

  end
end