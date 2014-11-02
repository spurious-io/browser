require 'aws-sdk'
require "base64"

class App
  module Views
    class DynamodbView < Layout
      attr_reader :client

      LIMIT = 10

      def client
        @client ||= AWS::DynamoDB::Client::V20120810.new
      end

      def item_count
        @item_count ||= client.describe_table({
          :table_name => table_name
        })[:table][:item_count]
      end

      def title
        "#{super} | DynamoDB - View"
      end

      def table_name
        @params['table_name']
      end

      def has_records
        item_count > 0
      end

      def items
        options = {
          :table_name => table_name,
          :limit      => LIMIT
        }

        options[:exclusive_start_key] = pagination_data['next'] unless pagination_data.nil? || pagination_data['next'].nil?
        items = client.scan(options)

        if items[:count] != 0
          headers = items[:member].first.reduce([]) { |accum, (key, data)| accum << key }

          item_arr = items[:member].reduce([]) do |accum, current|
            new_accum = current.reduce([]) do |accum_in, (key, value)|
              accum_in << "<td>#{value.values.first}</td>"
            end
            accum.tap { |a| a << new_accum.join("\n") }
          end
          items[:member].first.delete("location")

          @data ||= {
            :first      => pagination_data.nil? || pagination_data['next'].nil?,
            :last       => items[:last_evaluated_key].nil?,
            :headers    => headers,
            :data       => item_arr,
            :start_key  => items.fetch(:last_evaluated_key, nil)
          }
        end
      end

      def pagination
        previous_data = {
          :prev => pagination_data.nil? || pagination_data['prev'].nil? ? nil : pagination_data['prev']['p'],
          :next => pagination_data.nil? || pagination_data['prev'].nil? ? nil : pagination_data['prev']['n']
        }

        next_data = {
          :prev => pagination_data.nil? || pagination_data['next'].nil? ? nil : { 'n' => pagination_data['next'], 'p' => pagination_data['prev'] },
          :next => items[:start_key].to_h
        }

        @page ||= {
          :previous => "?key=#{Base64.encode64(previous_data.to_json)}",
          :next     => "?key=#{Base64.encode64(next_data.to_json)}"
        }
      end

      def pagination_data
        @pagination_data ||= (@params['key'] ? JSON.parse(Base64.decode64(@params['key'])) : nil)
      end
    end
  end
end

