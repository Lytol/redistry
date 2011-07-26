lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'redistry/version'
 
Gem::Specification.new do |s|
  s.name        = "redistry"
  s.version     = Redistry::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brian Smith"]
  s.email       = ["bsmith@swig505.com"]
  s.homepage    = "http://github.com/Lytol/redistry"
  s.summary     = "A set of useful Redis patterns/abstractions for Ruby (and Rails)"
  s.description = "A set of useful Redis patterns/abstractions for Ruby (and Rails)"
 
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "redistry"
 
  s.add_dependency("redis", ">= 2.2.1")

  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  s.require_path = 'lib'
end

