require 'aws-sdk'

class App
  module Views
    class DynamodbCreate < Layout

      def title
        "#{super} | DynamoDB - Create"
      end

    end
  end
end

