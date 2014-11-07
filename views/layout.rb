module Spurious
  module Browser
    module Views
      class Layout < Mustache
        def title
          "Spurious Browser"
        end

        def logged_in?
          @logged_in
        end
      end
    end
  end
end

