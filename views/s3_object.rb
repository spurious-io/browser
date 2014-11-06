require_relative "../models/s3"

module Spurious
  module Browser
    module Views
      class S3Object < Layout
        def content
          "S3 Browser"
        end

        def s3_path
          @params['object_path']
        end

        def navigation
          nav_parts = []
          current_path = '/s3'
          parts = @params['object_path'].split('/')

          parts.each do |part|
            current_path = "#{current_path}/#{part}"
            nav_parts << { :nav_path => current_path, :nav_name => part, :last => part == parts.last }
          end
          nav_parts
        end

        def objects
          object_path  = @params['object_path'].split('/')
          bucket_name = object_path.shift

          Models::S3.objects(bucket_name, object_path)
        end

        def title
          "#{super} | S3 | #{@params['object_path']}"
        end
      end
    end
  end
end

