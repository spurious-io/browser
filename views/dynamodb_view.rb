require 'aws-sdk'

class App
  module Views
    class DynamodbView < Layout

      def title
        "#{super} | DynamoDB - View"
      end

      def table_meta
        ddb = AWS::DynamoDB::Client::V20120810.new
        ddb.list_tables.table_names.map do |table_name|
          ddb.describe_table({ :table_name => table_name })[:table]
        end
      end

      def items
        items = AWS::DynamoDB::Client::V20120810.new.scan({
          :table_name => @params['table_name'],
          :limit      => 10
        })

        headers = []

        items[:member].first.each { |key, data| headers << key }

        item_arr = items[:member].reduce([]) do |accum, current|
          new_accum = current.reduce([]) do |accum_in, (key, value)|
            accum_in <<  value.values.first
          end
          accum << new_accum
          accum
        end
        {
          :headers => headers,
          :data   => item_arr
        }
      end

    end
  end
end

