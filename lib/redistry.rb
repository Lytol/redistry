require 'redis'
require 'redistry/version'
require 'redistry/list'
require 'redistry/serializers/json'

module Redistry
  extend self

  attr_accessor :client
  attr_reader   :loaded_frameworks

  def client
    @client ||= Redis.new
  end

  def setup!
    @loaded_frameworks = []

    setup_active_record! if defined?(ActiveRecord)
  end

  private

  def setup_active_record!
    require 'redistry/serializers/activerecord'
    ActiveRecord::Base.send(:include, Redistry::List)   
    @loaded_frameworks << :activerecord
  end
end

Redistry.setup!
