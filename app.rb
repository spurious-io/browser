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

  get '/sqs/:name/clear' do
    queue = AWS::SQS.new.queues.named(params['name'])
    while queue.approximate_number_of_messages > 0
      queue.receive_message(limit: 10) do |msg|
        queue.batch_delete(msg)
      end
    end
    redirect to('/sqs')
  end

  get '/s3' do
    mustache :s3
  end

  get '/s3/create' do
    mustache :s3_create
  end

  post '/s3/create' do
    AWS::S3.new.buckets.create(params['bucketName'])
    redirect to('/s3')
  end

  get '/s3/:bucket_name/clear' do
    AWS::S3.new.buckets[params['bucket_name']].clear!
    redirect to('/s3')
  end

  get '/s3/:bucket_name/delete' do
    AWS::S3.new.buckets[params['bucket_name']].delete!
  end

  get '/s3/view/*' do
    params['object_path'] = params[:captures][0]
    mustache :s3_object_view
  end

  get '/s3/preview/*' do
    params['object_path'] = params[:captures][0]
    path_parts  = params['object_path'].split('/')
    object = AWS::S3.new.buckets[path_parts.shift].objects[path_parts.join('/')]
    content_type object.content_type.empty? ? 'text/plain' : object.content_type
    object.read
  end

  get '/s3/add/*' do
    params['object_path'] = params[:captures][0]
    mustache :s3_object_add
  end

  post '/s3/add/*' do
    params['object_path'] = params[:captures][0]
    bucket = AWS::S3.new.buckets[params['bucket_name']]
  end

  get '/s3/*' do
    params['object_path'] = params[:captures][0]
    mustache :s3_object
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
