require "hemp/routing/route"
require "hemp/routing/route_syntax_error"
require "hemp/routing/route_extensions"
require "hemp/routing/route_split"

module Hemp
  module Aliases
    RouteAlias = Hemp::Routing::Route
    RouteError = Hemp::Routing::RouteSyntaxError
    RouteSplitter = Hemp::Routing::RouteSplitter
    RouteExtensions = Hemp::Routing::RouteExtensions
  end
end
