require "aws-sdk"

module Spurious
  module Browser
    module Models
      class SQS

        def self.client
          @@client ||= AWS::SQS.new
        end

        def self.queues
          client.queues.to_a.map do |queue|
            OpenStruct.new({
              :queue => queue,
              :name  => queue.url[/([^\/]+)$/,1]
            })
          end
        end

        def self.queue(name)
          client.queues.named name
        end

        def self.create(name)
          client.queues.create name
        end

        def self.send_message(queue_name, message)
          queue(queue_name).send_message(message)
        end

        def self.clear(queue_name)
          queue = queue(queue_name)
          while queue.approximate_number_of_messages > 0
            queue.receive_message(limit: 10) do |msg|
              queue.batch_delete(msg)
            end
          end
        end

        def self.delete(queue_name)
          queue(queue_name).delete
        end

      end
    end
  end
end

