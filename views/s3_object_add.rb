require 'nokogiri'

class App
  module Views
    class S3ObjectAdd < Layout
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
        require 'pry'
        path_parts  = @params['object_path'].split('/')
        bucket_name = path_parts.shift
        prefix = path_parts.length > 0 ? path_parts.join('/') : nil
        bucket = AWS::S3.new.buckets[bucket_name].as_tree(:prefix => prefix)

        bucket.children.to_a.map do |object|
          if object.respond_to?(:prefix)
            {
              :object_name => object.prefix[/([^\/]*)$/],
              :object_path => File.join(bucket_name, object.prefix),
              :is_dir      => true
            }
          else
            {
              :object_name    => object.key[/([^\/]*)$/],
              :object_path    => File.join('view', bucket_name, object.key),
              :content_type   => object.member.content_type,
              :content_length => object.member.content_length,
              :is_dir         => false
            }
          end
         end
      end

      def title
        "#{super} | S3 | Add | #{@params['object_path']}"
      end
    end
  end
end

