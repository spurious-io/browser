require 'nokogiri'

class App
  module Views
    class S3 < Layout
      def content
        "S3 Browser"
      end

      def buckets
        AWS::S3.new.buckets.to_a.map do |bucket|
          {
            :name          => bucket.name,
            :url           => bucket.url
          }
        end
      end

      def title
        "#{super} | S3"
      end
    end
  end
end

