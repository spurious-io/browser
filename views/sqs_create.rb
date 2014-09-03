require 'aws-sdk'

class App
  module Views
    class SqsCreate < Layout

      def title
        "#{super} | SQS - Create"
      end

    end
  end
end

