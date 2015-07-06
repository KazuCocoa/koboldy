# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'koboldy/version'

Gem::Specification.new do |spec|
  spec.name          = "koboldy"
  spec.version       = Koboldy::VERSION
  spec.authors       = ["Kazuaki MATSUO"]
  spec.email         = ["fly.49.89.over@gmail.com"]
  spec.summary       = %q{Support library for kobold which is nodejs app.}
  spec.description   = %q{Support library for kobold https://github.com/yahoo/kobold}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "rantly"
end
