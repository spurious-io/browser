require 'spurious/ruby/awssdk/helper'
require 'aws-sdk'

class App
  module Views
    class Sqs < Layout
      def content
        "Queues"
      end

      def queues
        AWS.config({
          :access_key_id     => 'development_access',
          :secret_access_key => 'development_secret',
          :region            => 'eu-westi-1'
        })

        Spurious::Ruby::Awssdk::Helper.configure
        AWS::SQS.new.queues.to_a.map do |queue|
          OpenStruct.new({
            :queue => queue,
            :name  => queue.url[/([^\/]+)$/,1]
          })
        end
      end

      def title
        "#{super} | SQS"
      end
    end
  end
end

