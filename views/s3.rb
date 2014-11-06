require_relative "../models/s3"

module Spurious
  module Browser
    module Views
      class S3 < Layout

        def title
          "#{super} | S3"
        end

        def content
          "S3 Browser"
        end

        def buckets_available?
          Models::S3.buckets.length > 0
        end

        def buckets
          Models::S3.buckets
        end

      end
    end
  end
end

