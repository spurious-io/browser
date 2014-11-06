require_relative '../app'

module Spurious
  module Browser
    module Routes
      class S3 < Spurious::Browser::App

        ROUTE = 's3'

        get '/%s' % ROUTE do
          mustache :s3
        end

        get '/%s/create' % ROUTE do
          mustache :s3_create
        end

        post '/%s/create' % ROUTE do
          AWS::S3.new.buckets.create(params['bucketName'])
          redirect to('/s3')
        end

        get '/%s/:bucket_name/clear' % ROUTE do
          AWS::S3.new.buckets[params['bucket_name']].clear!
          redirect to('/s3')
        end

        get '/%s/:bucket_name/delete' % ROUTE do
          AWS::S3.new.buckets[params['bucket_name']].delete!
        end

        get '/%s/view/*' % ROUTE do
          params['object_path'] = params[:captures][0]
          mustache :s3_object_view
        end

        get '/%s/preview/*' % ROUTE do
          params['object_path'] = params[:captures][0]
          path_parts  = params['object_path'].split('/')
          object = AWS::S3.new.buckets[path_parts.shift].objects[path_parts.join('/')]
          content_type object.content_type.empty? ? 'text/plain' : object.content_type
          object.read
        end

        get '/%s/add/*' % ROUTE do
          params['object_path'] = params[:captures][0]
          mustache :s3_object_add
        end

        post '/%s/add/*' % ROUTE do
          params['object_path'] = params[:captures][0]
          bucket = AWS::S3.new.buckets[params['bucket_name']]
        end

        get '/%s/* % ROUTE' do
          params['object_path'] = params[:captures][0]
          mustache :s3_object
        end
      end
    end
  end
end
