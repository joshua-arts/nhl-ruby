# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "nhl/version"

Gem::Specification.new do |spec|
  spec.name          = "nhl"
  spec.version       = NHL::VERSION
  spec.authors       = ["joshua-arts"]
  spec.email         = ["joshua.arts@carleton.ca"]

  spec.summary       = "A ruby wrapper for the official NHL API."
  spec.description   = "A ruby wrapper for the official NHL API."
  spec.homepage      = "http://hiimjosh.me"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "faraday"
end