require 'sinatra/base'
require 'mustache/sinatra'

class App < Sinatra::Base
  register Mustache::Sinatra
  require 'views/layout'

  set :mustache, {
    :views     => 'views/',
    :templates => 'templates/'
  }

  get '/' do
    mustache :index
  end

  get '/sqs' do
    mustache :sqs
  end

  get '/sqs/create' do
    mustache :sqs_create
  end

  post '/sqs/create' do
    AWS::SQS.new.queues.create params[:queueName]
    redirect to('/sqs')
  end

  get '/sqs/:name' do
    mustache :sqs_view
  end

  post '/sqs/:name' do
    queue = AWS::SQS.new.queues.named(params['name'])
    queue.send_message(params['sqsMessage'])
    redirect to('/sqs')
  end

  get '/sqs/:name/delete' do
    queue = AWS::SQS.new.queues.named(params['name'])
    while queue.approximate_number_of_messages > 0
      queue.receive_message(limit: 10) do |msg|
        queue.batch_delete(msg)
      end
    end
    queue.delete
    redirect to('/sqs')
  end

  get '/s3' do
    mustache :s3
  end

  get '/dynamodb' do
    mustache :dynamodb
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
