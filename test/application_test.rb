require_relative "test_helper"

class TestApplicationRespondsToCall < Minitest::Test
  attr_reader :app

  def setup
    @app = Hemp::Application.new
  end

  def test_call
    assert_respond_to app, :call
  end
end

class TestApplicationCallWithEmptyEnv < Minitest::Test
  attr_reader :app, :response

  def setup
    @app = Hemp::Application.new
    env = {}
    @response = app.call(env)
  end

  def test_response_code
    assert_equal response.status, 200
  end

  def test_hello_from_hemp_body
    assert_equal response.body, ["Hello from Hemp"]
  end
end
