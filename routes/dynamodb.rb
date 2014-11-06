require_relative '../app'

module Spurious
  module Browser
    module Routes
      class Dynamodb < Spurious::Browser::App

        namespace "/dynamodb" do

          get ''  do
            mustache :dynamodb
          end

          get '/create' do
            mustache :dynamodb_create
          end

          post '/create' do
            begin
              table_data = JSON::parse(params['tableData'], { :symbolize_names => true })
              client = AWS::DynamoDB::Client::V20120810.new

              if table_data[:table_name].nil?
                table_data[:table_name] = params['tableName']
              end

              client.create_table(table_data)

            rescue Exception => e
              redirect to("/dynamodb?error=#{e.message}")
            end

            redirect to('/dynamodb')
          end

          get '/:table_name/delete' do
            client = AWS::DynamoDB::Client::V20120810.new
            client.delete_table({:table_name => params['table_name'] })
            redirect to('/dynamodb')
          end

          get '/:table_name/view' do
            mustache :dynamodb_view
          end

        end
      end
    end
  end
end
