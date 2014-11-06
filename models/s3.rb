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

        def self.create(table_data)
          table_data[:table_name] = params['tableName'] if table_data[:table_name].nil?
          client.create_table table_data
        end

        def self.delete(table_name)
          client.delete_table {:table_name => table_name }
        end

      end
    end
  end
end

