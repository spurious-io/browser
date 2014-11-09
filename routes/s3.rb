require_relative "../app"
require_relative "../models/s3"

module Spurious
  module Browser
    module Routes
      class S3 < Spurious::Browser::App

        get '/?' do
          mustache :s3
        end

        get '/create' do
          mustache :s3_create
        end

        post '/create' do
          Models::S3.create params['bucketName']
          redirect to('/')
        end

        get '/:bucket_name/clear' do
          Models::S3.bucket(params['bucket_name']).clear!
          redirect to('/')
        end

        get '/:bucket_name/delete' do
          Models::S3.bucket(params['bucket_name']).delete!
        end

        get '/view/*' do
          params['object_path'] = params[:captures][0]
          mustache :s3_object_view
        end

        get '/preview/*' do
          params['object_path'] = params[:captures][0]
          path_parts  = params['object_path'].split('/')
          object = Models::S3.object(path_parts.shift, path_parts.join('/'))
          content_type object.content_type.empty? ? 'text/plain' : object.content_type
          object.read
        end

        get '/add/*' do
          params['object_path'] = params[:captures][0]
          mustache :s3_object_add
        end

        post '/add/*' do
          params['object_path'] = params[:captures][0]
          bucket = Models::S3.bucket params['bucket_name']
        end

        get '/*' do
          params['object_path'] = params[:captures][0]
          mustache :s3_object
        end
      end
    end
  end
end
