require_relative '../app'
require_relative '../models/dynamodb'

module Spurious
  module Browser
    module Routes
      class Dynamodb < Spurious::Browser::App

        get '/?'  do
          mustache :dynamodb
        end

        get '/create' do
          mustache :dynamodb_create
        end

        post '/create' do
          begin
            table_data = JSON::parse(params['tableData'], { :symbolize_names => true })
            Models::Dynamodb.create table_data
          rescue Exception => e
            redirect to("/?error=#{e.message}")
          end

          redirect to('/')
        end

        get '/:table_name/delete' do
          Models::Dynamodb.delete params['table_name']
          redirect to('/')
        end

        get '/:table_name/view' do
          mustache :dynamodb_view
        end

      end
    end
  end
end
