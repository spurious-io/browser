require 'aws-sdk'

class App
  module Views
    class DynamodbView < Layout

      LIMIT = 2

      def item_count
        AWS::DynamoDB::Client::V20120810.new.describe_table({
          :table_name => table_name
        })[:table][:item_count]
      end

      def title
        "#{super} | DynamoDB - View"
      end

      def table_name
        @params['table_name']
      end

      def items
        options = {
          :table_name => @params['table_name'],
          :limit      => LIMIT
        }

        options[:exclusive_start_key] = JSON::parse(URI::decode(@params['next_key'])) unless @params['next_key'].nil?
puts options.inspect

        items = AWS::DynamoDB::Client::V20120810.new.scan(options)

        if items[:count] != 0

          headers = []

          items[:member].first.each { |key, data| headers << key }

          item_arr = items[:member].reduce([]) do |accum, current|
            new_accum = current.reduce([]) do |accum_in, (key, value)|

              accum_in << "<td>#{value.values.first}</td>"
            end
            accum << new_accum.join("\n")
            accum
          end
          items[:member].first.delete("location")

          {
            :headers    => headers,
            :data       => item_arr,
            :start_key  => items.fetch(:last_evaluated_key, nil),
            :first_item => items[:member].last
          }
        end
      end

      def pagination
        pagination_data = items
        {
          :previous => @params['prev_key'].nil? ? '' : "?next_key=#{URI::encode(@params['prev_key'])}",
          :next => pagination_data[:start_key].nil? ? '' : "?prev_key=#{URI::encode(pagination_data[:first_item].to_h.to_json)}&next_key=#{URI::encode(pagination_data[:start_key].to_h.to_json)}"
        }

      end

    end
  end
end

