require_relative "test_helper"

class BaseTest < Minitest::Test
  attr_reader :base

  def setup
    @base = Hemp::Routing::Base.new
  end

  def test_routes_are_empty
    assert_empty base.routes
  end

  def test_responds_to_http_verbs
    assert_respond_to base, :get
    assert_respond_to base, :post
    assert_respond_to base, :put
    assert_respond_to base, :patch
    assert_respond_to base, :delete
  end

  def test_raises_error_when_routes_are_invalid_because_to_is_not_passed_in
    base.prepare do
      post "/users", "users#show"
    end
  rescue Hemp::Routing::RouteSyntaxError => e
    assert_includes e.message, "Controller hash does not contain 'to' key"
  end

  def test_raises_error_when_controller_action_pattern_is_invalid
    base.prepare do
      post "/users", to: "users/show"
    end
  rescue Hemp::Routing::RouteSyntaxError => e
    assert_includes e.message,
                    "Controller action does not meet required pattern"
  end

  def test_raises_error_when_route_path_is_blank
    base.prepare do
      delete "", to: "users#destroy"
    end
  rescue Hemp::Routing::RouteSyntaxError => e
    assert_includes e.message, "Route should not be a blank string"
  end

  def test_routes_are_well_parsed
    base.prepare do
      post "/users", to: "users#new"
      get "/users/:id", to: "users#show"
      put "/users/:id", to: "users#update"
      delete "/users/:id", to: "users#destroy"
    end
  end
end
