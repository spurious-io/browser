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
        require 'pry'
        bucket = AWS::S3.new.buckets[@params['object_path']].as_tree
        binding.pry
        bucket.children.to_a.map do |object|
          binding.pry
          item = object.object
          is_dir = item.key =~ /\//
          item_key = is_dir ? item.key[/(.*)\//, 1] : item.key
          {
            :object_key      => item_key,
            :content_type    => item.content_type,
            :content_length  => item.content_length,
            :object_path     => "#{s3_path}/#{item_key}",
            :is_dir          => is_dir
          }
         end
      end

      def title
        "#{super} | S3 | #{@params['object_path']}"
      end
    end
  end
end

