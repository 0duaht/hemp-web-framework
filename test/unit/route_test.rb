require_relative "../test_helper"

class RouteTest < Minitest::Test
  attr_reader :route

  def setup
    controller_action_string = "string#new"
    regex = Regexp.new("/users/new/[a-zA-Z0-9_]+")
    url_vars = { 3 => "id" }
    @route = Hemp::Routing::Route.new(
      controller_action_string, regex, url_vars
    )
  end

  def test_route_returns_right_controller_camel_string
    assert_equal route.controller_camel, "StringController"
  end

  def test_route_returns_correct_action_symbol
    assert_equal route.action_sym, :new
  end

  def test_route_returns_right_controller_snake_string
    assert_equal route.controller_snake, "string_controller"
  end

  def test_route_does_not_match_incorrect_path
    refute route == "/users"
    refute route == "/user/new"
  end

  def test_route_matches_correct_path
    assert route == "/users/new/68"
  end

  def test_getting_url_variables
    assert_equal route.get_url_vars("/users/new/68"), "id" => "68"
  end
end
