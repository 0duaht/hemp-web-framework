require_relative "test_helper"

class TestOrmApplication < Minitest::Test
  attr_reader :model, :invalid_model

  def setup
    set_up_full_app_and_routes
  end

  def teardown
    File.delete model
    File.delete invalid_model
  end

  def set_up_full_app_and_routes
    setup_instance_vars
    create_valid_model_file
    create_invalid_model_file
  end

  def setup_instance_vars
    @model = "wrap.rb"
    @invalid_model = "whiff.rb"
  end

  def create_valid_model_file
    File.open(model, "w") do |file|
      file.write(model_class_body)
      current_dir = File.expand_path("..", file)
      $LOAD_PATH.unshift current_dir
    end
  end

  def create_invalid_model_file
    File.open(invalid_model, "w") do |file|
      file.write(invalid_type_model_class_body)
      current_dir = File.expand_path("..", file)
      $LOAD_PATH.unshift current_dir
    end
  end

  def invalid_type_model_class_body
    <<-STRING
      require "hemp/base_record"
      class Whiff < Hemp::BaseRecord
        to_table :whiffs
        property :id, type: :integer, primary_key: true
      end
    STRING
  end

  def model_class_body
    <<-STRING
      require "hemp/base_record"
      class Wrap < Hemp::BaseRecord
        to_table :wraps
        property :id, type: :integer, primary_key: true
        property :price, type: :integer, nullable: false
        property :dealer_name, type: :text, nullable: false

        create_table
      end
    STRING
  end

  def test_instantiating_invalid_model
    assert_raises SystemExit do
      capture_io do
        Whiff.property :whiff_speed, type: :speed, nullable: false
      end
    end
  end

  def test_instantiating_model_returns_an_instance_of_the_model
    wrap = Wrap.new
    assert_instance_of Wrap, wrap
  end

  def test_instantiating_model_with_attributes_hash
    wrap = Wrap.new(price: 1000, dealer_name: "Skinny")
    assert_equal wrap.dealer_name, "Skinny"
    assert_equal wrap.price, 1000
  end

  def test_creating_records
    wrap = Wrap.create(price: 1000, dealer_name: "Skinny")
    assert 1, Wrap.count
    assert_includes Wrap.all, Wrap.find(wrap.id)
    Wrap.destroy_all
  end

  def test_updating_a_record
    wrap = Wrap.new(price: 1000, dealer_name: "Skinny")
    wrap.save
    wrap.price = 1500
    wrap.update
    assert_equal Wrap.find(wrap.id).price, 1500
    Wrap.destroy_all
  end

  def test_creating_records_with_invalid_attributes_fail
    refute Wrap.create(price: 1000)
  end

  def test_updating_a_record_with_invalid_attributes_fails
    wrap = Wrap.new(price: 1000, dealer_name: "Skinny")
    wrap.save
    wrap.price = nil
    refute wrap.update
    Wrap.destroy_all
  end

  def test_destroying_a_record
    wrap = Wrap.new(price: 1000, dealer_name: "Skinny")
    wrap.destroy
    assert_empty Wrap.all
  end

  def test_destroying_all_records
    wrap = Wrap.new(price: 1000, dealer_name: "Skinny")
    wrap.save
    Wrap.destroy_all
    assert_empty Wrap.all
  end
end
