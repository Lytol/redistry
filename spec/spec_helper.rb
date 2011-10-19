require 'rubygems'
require 'bundler/setup'
require 'redistry'

RSpec.configure do |config|
  # some (optional) config here
end

module Redistry
  def loaded_frameworks=(frameworks)
    @loaded_frameworks = frameworks
  end
end

