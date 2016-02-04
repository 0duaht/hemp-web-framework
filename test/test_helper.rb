$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require "hemp"
require "minitest/spec"
require "minitest/autorun"
require "minitest/unit"
require "fileutils"

class MyTest < Minitest::Unit
  after_tests do
    FileUtils.rm_rf "db"
  end
end
