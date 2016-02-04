# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hemp/version"

Gem::Specification.new do |spec|
  spec.name          = "hemp"
  spec.version       = Hemp::VERSION
  spec.authors       = ["Tobi Oduah"]
  spec.email         = ["tobi.oduah@andela.com"]

  spec.summary       = "Simple web framework for building web apps in Ruby "\
                        "following the MVC design pattern"
  spec.description   = "Simple web framework for building web apps in Ruby "\
                        "following the MVC design pattern"
  spec.homepage      = "https://github.com/andela-toduah/hemp-web-framework"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem "\
          "pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 1.10"
  spec.add_dependency "rake", "~> 10.0"
  spec.add_dependency "rack"
  spec.add_dependency "rack-test"
  spec.add_dependency "facets"
  spec.add_dependency "minitest"
  spec.add_dependency "erubis"
  spec.add_dependency "tilt"
  spec.add_dependency "sqlite3"
  spec.add_dependency "codeclimate-test-reporter"
end
