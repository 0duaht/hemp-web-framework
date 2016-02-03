require_relative "../test_helper"
require "rack/test"

class TestIntegrationApp < Minitest::Test
  include Rack::Test::Methods
  self.class.attr_accessor :count, :app
  self.count = 0

  def app
    self.class.app ||= Rack::Builder.parse_file(
      "#{__dir__}/hemp_todo/config.ru").first
  end

  def test_adding_new_fellow
    create_fellow
    assert_equal Fellow.all.size, 1
    Fellow.destroy_all
  end

  def create_fellow
    post "/fellows",
         first_name: "Tobi", last_name: "Oduah", email: "testvalue@gmail.com",
         stack: "ruby"
    self.class.count = self.class.count + 1
  end

  def test_visiting_root_path
    get "/"
    assert last_response.ok?
  end

  def test_visiting_fellow_path
    create_fellow
    get "/fellows/#{self.class.count}"
    assert last_response.ok?
    assert last_response.body.include? "Tobi"
    assert last_response.body.include? "testvalue@gmail.com"
    Fellow.destroy_all
  end

  def test_updating_a_fellow
    create_fellow
    assert_equal Fellow.find(self.class.count).stack, "ruby"
    put "/fellows/#{self.class.count}",
        first_name: "Tobi", last_name: "Oduah", email: "testvalue@gmail.com",
        stack: "Hemp"
    assert_equal Fellow.find(self.class.count).stack, "Hemp"
    Fellow.destroy_all
  end

  def test_deleting_a_fellow
    create_fellow
    assert_equal Fellow.all.size, 1
    delete "/fellows/#{self.class.count}"
    assert_equal Fellow.all.size, 0
  end
end
