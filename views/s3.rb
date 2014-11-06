require 'nokogiri'

module Spurious
  module Browser
    module Views
      class S3 < Layout
        def content
          "S3 Browser"
        end

        def buckets_available?
          buckets.length > 0
        end

        def buckets
          @buckets ||= client.buckets.to_a.map do |bucket|
            {
              :name          => bucket.name,
              :url           => bucket.url
            }
          end
        rescue AWS::S3::Errors::NoSuchBucket
          {}
        end

        def title
          "#{super} | S3"
        end

        protected

        def client
          @client ||= AWS::S3.new
        end

      end
    end
  end
end

