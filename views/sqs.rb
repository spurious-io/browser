require "aws-sdk"
require_relative "../models/sqs"

module Spurious
  module Browser
    module Views
      class Sqs < Layout
        def content
          "Queues"
        end

        def title
          "#{super} | SQS"
        end

        def queues_available?
          queues.length > 0
        end

        def queues
          Models::SQS.queues
        end
      end
    end
  end
end

