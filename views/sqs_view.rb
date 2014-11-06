require 'aws-sdk'

module Spurious
  module Browser
    module Views
      class SqsView < Layout
        def content
          @params[:name]
        end

        def queues
          AWS::SQS.new.queues.to_a
        end

        def title
          "#{super} | SQS - #{content}"
        end

      end
    end
  end
end

