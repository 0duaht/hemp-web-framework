require "hemp/aliases"

module Hemp
  module Routing
    class Base
      include Hemp::Aliases
      include RouteExtensions

      attr_reader :routes

      SUPPORTED_VERB_LIST = %w(get delete patch post put).freeze

      def initialize
        @routes = {}
        verb_helper SUPPORTED_VERB_LIST
      end

      def prepare(&block)
        instance_eval(&block)
      end

      def verb_helper(verbs)
        verbs.each do |verb|
          self.class.
            send(:define_method, verb) do |route_path, controller_hash|
            hash_error(controller_hash) unless hash_valid? controller_hash
            process_route_line verb, route_path, controller_hash[:to]
          end
        end
      end

      def process_route_line(verb, route_path, controller_action)
        handle_errors route_path, controller_action
        route_args = parse_route_args(route_path.split("/"))
        route_object = RouteAlias.new(controller_action, *route_args)
        save_to_routes verb, route_object
      end

      def handle_errors(route_path, controller_action)
        verify_route_path route_path
        verify_controller_action controller_action
      end

      def verify_controller_action(controller_action)
        error_constructor(
          controller_action, "Controller action does not meet required pattern"
        ) if (controller_action =~ /^[a-zA-Z0-9_]+#[a-zA-Z0-9_]+$/).nil?
      end

      def verify_route_path(route_path)
        error_constructor(
          route_path, "Route should not be a blank string"
        ) if route_path.empty?
      end

      def parse_route_args(split_route_path)
        route_split_helper = RouteSplitter.new(split_route_path)

        route_split_helper.parse_regex_and_vars_from_route
      end

      def save_to_routes(verb, route_object)
        routes[verb.to_sym] ||= []
        routes[verb.to_sym] << route_object
      end

      def hash_error(controller_hash)
        error_constructor(
          controller_hash,
          "Controller hash does not contain 'to' key"
        )
      end

      def hash_valid?(controller_hash)
        controller_hash.class == Hash && controller_hash.include?(:to)
      end

      def error_constructor(line, error_message)
        raise RouteError.new line, error_message
      end
    end
  end
end
