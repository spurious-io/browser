require 'nokogiri'

class App
  module Views
    class S3 < Layout
      def content
        "S3 Browser"
      end

      def buckets
        url = URI.parse("http://#{AWS.config.s3_endpoint}:#{AWS.config.s3_port}")
        req = Net::HTTP::Get.new(url.to_s)
        doc  = Nokogiri::XML(req.body)
        require 'pry'
        binding.pry
        AWS::S3.new.buckets.to_a
      end

      def title
        "#{super} | S3"
      end
    end
  end
end

