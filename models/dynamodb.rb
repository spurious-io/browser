require "aws-sdk"

module Spurious
  module Browser
    module Models
      class Dynamodb

        def self.client
          @@client ||= AWS::DynamoDB::Client::V20120810.new
        end

        def self.tables
          client.list_tables.table_names.map do |table_name|
            client.describe_table({ :table_name => table_name })[:table]
          end
        end

        def self.create(table_data)
          table_data[:table_name] = params['tableName'] if table_data[:table_name].nil?
          client.create_table table_data
        end

        def self.delete(table_name)
          client.delete_table({:table_name => table_name })
        end

        def self.table_length(table_name)
          client.describe_table({
            :table_name => table_name
          })[:table][:item_count]
        end

        def self.query(table_name, limit, start_key = nil)
          options = {
            :table_name => table_name,
            :limit      => limit
          }

          options[:exclusive_start_key] = start_key if start_key
          items = client.scan(options)

          if items[:count] > 0
            headers = items[:member].first.reduce([]) { |accum, (key, data)| accum << key }

            item_arr = items[:member].reduce([]) do |accum, current|
              new_accum = current.reduce([]) do |accum_in, (key, value)|
                accum_in << "<td>#{value.values.first}</td>"
              end
              accum.tap { |a| a << new_accum.join("\n") }
            end
            items[:member].first.delete("location")

            {
              :last       => items[:last_evaluated_key].nil?,
              :headers    => headers,
              :data       => item_arr,
              :start_key  => items.fetch(:last_evaluated_key, nil)
            }
          end
        end

      end
    end
  end
end

