require_relative "../models/dynamodb"

module Spurious
  module Browser
    module Views
      class Dynamodb < Layout
        def content
          "DynamoDB Browser"
        end

        def title
          "#{super} - DynamoDB"
        end

        def tables_available?
          tables.length > 0
        end

        def tables
          Models::Dynamodb.tables
        end
      end
    end
  end
end


