require_relative "../test_helper"

class TestRouteSyntaxError < Minitest::Test
  RouteError = Hemp::Routing::RouteSyntaxError

  def test_route_syntax_error_without_custom_message
    method_path = "wrong_route_syntax"
    raise RouteError.new method_path
  rescue RouteError => e
    assert_equal e.message, "Error while parsing routes. "\
      "See line containing - '#{method_path}'. "
  end

  def test_route_syntax_error_with_custom_message
    method_path = "wrong_route_syntax"
    custom_message = "Controller action does not meet required pattern"
    raise RouteError.new method_path, custom_message
  rescue RouteError => e
    assert_equal e.message, "Error while parsing routes. "\
      "See line containing - '#{method_path}'. #{custom_message}"
  end
end
