require "aws-sdk"

module Spurious
  module Browser
    module Models
      class S3

        def self.client
          @@client ||= AWS::S3.new
        end

        def self.buckets
          @@buckets ||= client.buckets.to_a.map do |bucket|
            {
              :name          => bucket.name,
              :url           => bucket.url
            }
          end
        rescue AWS::S3::Errors::NoSuchBucket
          {}
        end

        def self.bucket(name)
          client.buckets[name]
        end

        def self.objects(bucket_name, object_path)
          prefix = object_path.length > 0 ? object_path.join('/') : nil
          bucket = client.buckets[bucket_name].as_tree(:prefix => prefix)

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

        def self.object(bucket, path)
          object = client.buckets[bucket].objects[path]
          meta = [
            {
              :metadata_key   => 'Content type',
              :metadata_value => object.content_type,
            },
            {
              :metadata_key   => 'Length',
              :metadata_value => object.content_length
            },
            {
              :metadata_key   => 'Etag',
              :metadata_value => object.etag
            },
            {
              :metadata_key   => 'Last modified',
              :metadata_value => object.last_modified
            }
          ]

          meta.tap do |m|
            object.metadata.to_h.each do |key, value|
              m << {
                :metadata_key   => key,
                :metadata_value => value
              }
            end
          end

        end

        def self.create(table_data)
          table_data[:table_name] = params['tableName'] if table_data[:table_name].nil?
          client.create_table table_data
        end

        def self.delete(table_name)
          client.delete_table({:table_name => table_name })
        end

      end
    end
  end
end

