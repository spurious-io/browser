require "aws-sdk"

module Spurious
  module Browser
    module Models
      class Dynamodb

        def self.client
          @@client ||= AWS::DynamoDB::Client::V20120810.new
        end

        def self.tables
          @@tables ||= client.list_tables.table_names.map do |table_name|
            client.describe_table({ :table_name => table_name })[:table]
          end
        end

        def self.create(table_data)
          table_data[:table_name] = params['tableName'] if table_data[:table_name].nil?
          client.create_table table_data
        end

        def self.delete(table_name)
          client.delete_table {:table_name => table_name }
        end

      end
    end
  end
end

