require "facets"

module Hemp
  module Routing
    class Route
      attr_reader :controller_action, :regex_match, :url_variables

      def initialize(controller_action, regex_match, url_variables = {})
        @controller_action = controller_action.split("#")
        @regex_match = regex_match
        @url_variables = url_variables
      end

      def controller
        @controller_action[0]
      end

      def action
        @controller_action[1]
      end

      def controller_class
        controller << "_controller"
      end

      def controller_camel
        controller_class.camelcase :upper
      end

      def action_sym
        action.to_sym
      end

      def controller_snake
        controller_class.snakecase
      end

      def ==(other)
        (regex_match =~ other) == 0
      end
    end
  end
end
