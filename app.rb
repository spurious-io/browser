require "sinatra/base"
require "mustache/sinatra"
require "views/layout"

module Spurious
  module Browser
    class App < Sinatra::Base
      register Mustache::Sinatra

      set :sessions => true
      set :mustache, {
        :views     => File.join(File.dirname(__FILE__), 'views'),
        :templates => File.join(File.dirname(__FILE__), 'templates'),
        :namespace => Spurious::Browser
      }

      register do
        def auth (type)
          condition do
            redirect "/login" unless send("is_authenticated?")
          end
        end
      end

      helpers do
        def is_authenticated?
          session[:credentials]
        end
      end

      before /^(?!\/(login))/ do
        if session[:credentials]
          AWS.config session[:credentials]
          @logged_in = true
        else
          redirect '/login'
        end
      end

      get '/' do
        mustache :index
      end

      get '/login' do
        mustache :login
      end

      post '/login' do
        session[:credentials] = {
          :access_key_id     => params['accessKeyId'],
          :secret_access_key => params['secretAccessKey'],
          :region            => params['region']
        }
        redirect '/'
      end

      get '/logout' do
        session.delete(:credentials)
        redirect '/login'
      end

      get '/secure/place' do
        erb "This is a secret place that only <%=session[:identity]%> has access to!"
      end
    end
  end
end
