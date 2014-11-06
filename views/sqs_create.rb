require 'aws-sdk'

module Spurious
  module Browser
    module Views
      class SqsCreate < Layout

        def title
          "#{super} | SQS - Create"
        end

      end
    end
  end
end

