class App
  module Views
    class Dynamodb < Layout
      def content
        "DynamoDB Browser"
      end

      def title
        "#{super} - DynamoDB"
      end
    end
  end
end

