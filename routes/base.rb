require 'sinatra/base'
require 'sinatra/namespace'
require 'mustache/sinatra'
require 'views/layout'

module Spurious
  module Browser
    module Routes
      class Base < Sinatra::Base
        register Mustache::Sinatra
        register Sinatra::Namespace

        set :mustache, {
          :views     => File.join(File.dirname(__FILE__), '..', 'views'),
          :templates => File.join(File.dirname(__FILE__), '..', 'templates'),
          :namespace => Spurious::Browser
        }
      end
    end
  end
end
