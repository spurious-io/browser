require_relative '../app'

module Spurious
  module Browser
    module Routes
      class S3 < Spurious::Browser::App

        get '' do
          mustache :s3
        end

        get '/create' do
          mustache :s3_create
        end

        post '/create' do
          AWS::S3.new.buckets.create(params['bucketName'])
          redirect to('/s3')
        end

        get '/:bucket_name/clear' do
          AWS::S3.new.buckets[params['bucket_name']].clear!
          redirect to('/s3')
        end

        get '/:bucket_name/delete' do
          AWS::S3.new.buckets[params['bucket_name']].delete!
        end

        get '/view/*' do
          params['object_path'] = params[:captures][0]
          mustache :s3_object_view
        end

        get '/preview/*' do
          params['object_path'] = params[:captures][0]
          path_parts  = params['object_path'].split('/')
          object = AWS::S3.new.buckets[path_parts.shift].objects[path_parts.join('/')]
          content_type object.content_type.empty? ? 'text/plain' : object.content_type
          object.read
        end

        get '/add/*' do
          params['object_path'] = params[:captures][0]
          mustache :s3_object_add
        end

        post '/add/*' do
          params['object_path'] = params[:captures][0]
          bucket = AWS::S3.new.buckets[params['bucket_name']]
        end

        get '/*' do
          params['object_path'] = params[:captures][0]
          mustache :s3_object
        end
      end
    end
  end
end
