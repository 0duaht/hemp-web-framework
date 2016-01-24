$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require "simplecov"
SimpleCov.start
require "hemp"
require "hemp/routing/base"
require "hemp/routing/route"
require "hemp/routing/route_syntax_error"
require "mocha/mini_test"
require "minitest/spec"
require "minitest/autorun"
require "minitest/unit"
