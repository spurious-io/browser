module Spurious
  module Browser
    module Views
      class SqsView < Layout
        def content
          @params[:name]
        end

        def title
          "#{super} | SQS - #{content}"
        end

      end
    end
  end
end

