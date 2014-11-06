require 'aws-sdk'

module Spurious
  module Browser
    module Views
      class DynamodbCreate < Layout

        def title
          "#{super} | DynamoDB - Create"
        end

      end
    end
  end
end

