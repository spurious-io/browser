require 'nokogiri'

class App
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

        @params['object_path'].split('/').each do |part|
          current_path = "#{current_path}/#{part}"
          nav_parts << { :nav_path => current_path, :nav_name => part }
        end
        nav_parts
      end

      def objects
        bucket = AWS::S3.new.buckets[@params['object_path']]
        require 'pry'
        binding.pry
        bucket.objects
        # bucket.objects.map do |object|
        #   {
        #     :object_key      => object.key,
        #     :object_modified => object.last_modified,
        #     :content_type    => object.content_type,
        #   }
        # end
      end

      def title
        "#{super} | S3 | #{@params['object_path']}"
      end
    end
  end
end

