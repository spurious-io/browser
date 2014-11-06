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
          ddb = AWS::DynamoDB::Client::V20120810.new
          @tables ||= ddb.list_tables.table_names.map do |table_name|
            ddb.describe_table({ :table_name => table_name })[:table]
          end
        end
      end
    end
  end
end


