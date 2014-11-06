module Spurious
  module Browser
    module Views
      class Index < Layout
        def title
          "#{super} - Home"
        end

        def content
          "Welcome to the browser, please select a service above."
        end
      end
    end
  end
end
