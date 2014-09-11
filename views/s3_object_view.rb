require 'nokogiri'

class App
  module Views
    class S3ObjectView < Layout

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

      def data
        path_parts  = @params['object_path'].split('/')
        bucket_name = path_parts.shift
        bucket = AWS::S3.new.buckets[bucket_name]
        bucket.objects[path_parts.join('/')].read
      end

      def title
        "#{super} | S3 | View | #{@params['object_path']}"
      end
    end
  end
end

