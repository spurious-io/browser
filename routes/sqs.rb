require_relative "../app"
require_relative "../models/sqs"

module Spurious
  module Browser
    module Routes
      class SQS < Spurious::Browser::App

        get '/?' do
          mustache :sqs
        end

        get '/create' do
          mustache :sqs_create
        end

        post '/create' do
          Models::SQS.create params[:queueName]
          redirect to('/')
        end

        get '/:name' do
          mustache :sqs_view
        end

        post '/:name' do
          Models::SQS.send_message(params['name'], params['sqsMessage'])
          redirect to('/')
        end

        get '/:name/delete' do
          Models::SQS.clear params['name']
          Models::SQS.delete params['name']
          redirect to('/')
        end

        get '/:name/clear' do
          Models::SQS.clear params['name']
          redirect to('/')
        end

      end
    end
  end
end

