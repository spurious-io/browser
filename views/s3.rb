require 'nokogiri'

class App
  module Views
    class S3 < Layout
      def content
        "S3 Browser"
      end

      def buckets
        uri = URI("http://#{AWS.config.s3_endpoint}:#{AWS.config.s3_port}")
        doc = Nokogiri::XML(Net::HTTP.get(uri))

        buckets = doc.search('Contents').select do |item|
          item.search('Key').first.content !~ /\//
        end.map do |xml_element|
          bucket_name = xml_element.search('Key').first.content
          {
            :name          => bucket_name,
            :last_modified => xml_element.search('LastModified').first.content
          }
        end
      end

      def title
        "#{super} | S3"
      end
    end
  end
end

