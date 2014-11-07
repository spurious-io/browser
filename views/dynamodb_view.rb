require "aws-sdk"
require "base64"
require_relative "../models/dynamodb"

module Spurious
  module Browser
    module Views
      class DynamodbView < Layout
        attr_reader :client

        LIMIT = 10

        def title
          "#{super} | DynamoDB - View"
        end

        def table_name
          @params['table_name']
        end

        def has_records
          Models::Dynamodb.table_length(table_name) > 0
        end

        def start_key
          (pagination_data.nil? || pagination_data['next'].nil?) ? nil : pagination_data['next']
        end

        def items
          @items ||= Models::Dynamodb.query(table_name, LIMIT, start_key).tap do |items|
            items[:first] = pagination_data.nil? || pagination_data['next'].nil?
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
end

