prefix = "hemp/routing".freeze
require "#{prefix}/route"
require "#{prefix}/route_syntax_error"
require "#{prefix}/route_split"

module Hemp
  module Routing
    class Base
      attr_reader :routes

      RouteAlias = Hemp::Routing::Route
      RouteError = Hemp::Routing::RouteSyntaxError
      RouteSplitter = Hemp::Routing::RouteSplitter

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
            if controller_hash.class == Hash && controller_hash.include?(:to)
              process_route_line verb, route_path, controller_hash[:to]
            else
              error_constructor(
                controller_hash,
                "Controller hash does not contain 'to' key"
              )
            end
          end
        end
      end

      def process_route_line(verb, route_path, controller_action)
        handle_errors route_path, controller_action
        route_args = pick_out_url_variables(route_path.split("/"))
        route_object = RouteAlias.new(controller_action, *route_args)
        routes[verb.to_sym] ||= []
        routes[verb.to_sym] << route_object
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

      def pick_out_url_variables(split_route_path)
        route_split_helper = RouteSplitter.new(split_route_path)
        route_split_helper.pick_out_url_variables
        variable_hash = route_split_helper.url_variable_hash
        regex_match = route_split_helper.url_regex_match

        regex_string = "^" << regex_match.join("/") << "/*$"

        [Regexp.new(regex_string), variable_hash]
      end

      def error_constructor(line, error_message)
        raise RouteError.new line, error_message
      end
    end
  end
end
