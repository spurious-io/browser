require_relative '../app'

module Spurious
  module Browser
    module Routes
      class SQS < Spurious::Browser::App

        get '' do
          mustache :sqs
        end

        get '/create' do
          mustache :sqs_create
        end

        post '/create' do
          AWS::SQS.new.queues.create params[:queueName]
          redirect to('/sqs')
        end

        get '/:name' do
          mustache :sqs_view
        end

        post '/:name' do
          queue = AWS::SQS.new.queues.named(params['name'])
          queue.send_message(params['sqsMessage'])
          redirect to('/sqs')
        end

        get '/:name/delete' do
          queue = AWS::SQS.new.queues.named(params['name'])
          while queue.approximate_number_of_messages > 0
            queue.receive_message(limit: 10) do |msg|
              queue.batch_delete(msg)
            end
          end
          queue.delete
          redirect to('/sqs')
        end

        get '/:name/clear' do
          queue = AWS::SQS.new.queues.named(params['name'])
          while queue.approximate_number_of_messages > 0
            queue.receive_message(limit: 10) do |msg|
              queue.batch_delete(msg)
            end
          end
          redirect to('/sqs')
        end

      end
    end
  end
end

