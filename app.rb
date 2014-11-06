require 'sinatra/base'
require 'mustache/sinatra'
require 'views/layout'

module Spurious
  module Browser
    class App < Sinatra::Base
      register Mustache::Sinatra

      set :mustache, {
        :views     => File.join(File.dirname(__FILE__), 'views'),
        :templates => File.join(File.dirname(__FILE__), 'templates'),
        :namespace => Spurious::Browser
      }

      get '/' do
        mustache :index
      end

      # get '/login/form' do
      #   mustache :login_form
      # end

      # post '/login/attempt' do
      #   session[:identity] = params['username']
      #   where_user_came_from = session[:previous_url] || '/'
      #   redirect to where_user_came_from
      # end

      # get '/logout' do
      #   session.delete(:identity)
      #   erb "<div class='alert alert-message'>Logged out</div>"
      # end


      # get '/secure/place' do
      #   erb "This is a secret place that only <%=session[:identity]%> has access to!"
      # end
    end
  end
end
