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
        controller + "_controller"
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

      def get_url_vars(path_info)
        path_elements = path_info.split("/")
        var_collection = {}
        url_variables.each_key do |index|
          var_collection[url_variables[index]] = path_elements[index]
        end

        var_collection
      end

      def ==(other)
        (regex_match =~ other) == 0
      end
    end
  end
end
