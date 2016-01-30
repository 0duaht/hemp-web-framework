require_relative "test_helper"

class TestExtensions < Minitest::Test
  def test_hash_extension
    fellow = { first_name: "Tobi", last_name: "Oduah", project: "Hemp" }
    sliced_values = fellow.slice(:first_name, :last_name)
    assert_equal sliced_values.length, 2
    assert_equal sliced_values, first_name: "Tobi", last_name: "Oduah"
  end

  def test_object_extension
    invalid_class = InvalidClass
    assert_equal invalid_class, nil
  end
end
