require 'rubygems'
require 'bundler/setup'
require 'redistry'

RSpec.configure do |config|
  # some (optional) config here
end

def set_loaded_frameworks(*frameworks)
  frameworks =[frameworks].flatten

  Redistry.instance_eval do
    @loaded_frameworks = frameworks
  end
end

