require 'nokogiri'

module Spurious
  module Browser
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

        def metadata
          path_parts  = @params['object_path'].split('/')
          bucket_name = path_parts.shift
          object = AWS::S3.new.buckets[bucket_name].objects[path_parts.join('/')]
          meta = [
            {
              :metadata_key    => 'Content type',
              :metadata_value  => object.content_type,
            },
            {
              :metadata_key => 'Length',
              :metadata_value => object.content_length
            },
            {
              :metadata_key => 'Etag',
              :metadata_value => object.etag
            },
            {
              :metadata_key => 'Last modified',
              :metadata_value => object.last_modified
            }
          ]

          object.metadata.to_h.each do |key, value|
            meta << {
              :metadata_key => key,
              :metadata_value => value
            }
          end

          meta

        end

        def title
          "#{super} | S3 | View | #{@params['object_path']}"
        end
      end
    end
  end
end

