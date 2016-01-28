module Hemp
  module Routing
    class RouteSyntaxError < StandardError
      def initialize(method_path, custom_message = "")
        super "Error while parsing routes. "\
        "See line containing - '#{method_path}'. #{custom_message}"
      end
    end
  end
end
