module Hemp
  module Routing
    class RouteSplitter
      attr_accessor :split_route_path, :url_variable_hash, :url_regex_match

      def initialize(split_route_path)
        @split_route_path = split_route_path
        @url_variable_hash = {}
        @url_regex_match = []
      end

      def pick_out_url_variables
        split_route_path.each_with_index do |split_element, index|
          if split_element.start_with?(":")
            url_regex_match << save_variable_and_index(split_element, index)
          else
            url_regex_match << split_element
          end
        end
      end

      def save_variable_and_index(split_element, index)
        variable_key = split_element.delete(":")
        url_variable_hash[index] = variable_key.to_sym

        "[a-zA-Z0-9_]+"
      end

      def parse_regex_and_vars_from_route
        pick_out_url_variables
        regex_string = "^" << url_regex_match.join("/") << "/*$"

        [Regexp.new(regex_string), url_variable_hash]
      end
    end
  end
end
