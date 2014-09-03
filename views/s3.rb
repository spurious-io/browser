class App
  module Views
    class S3 < Layout
      def content
        "S3 Browser"
      end

      def title
        "#{super} - S3"
      end
    end
  end
end

