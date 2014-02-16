# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dyna_struct/version'

Gem::Specification.new do |spec|
  spec.name          = "dyna_struct"
  spec.version       = DynaStruct::VERSION
  spec.authors       = ["JC Wilcox"]
  spec.email         = ["84jwilcox@gmail.com"]
  spec.summary       = %q{An alternative to Ruby's Struct, DynaStruct allows dynamic assignement of instance variables.}
  spec.description   = %q{DynaStruct offers a number of classes which provide different ways to dynamically assign and interact with instance variables. This is accomplished through Ruby's metaprogramming, which allows the dynamic manipulation of data and methods for a specific object.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
