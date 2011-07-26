require 'redis'
require 'redistry/version'
require 'redistry/serializers/activerecord'
require 'redistry/has_list'

module Redistry
  extend self

  attr_accessor :client, :serializer

  def client
    @client ||= Redis.new
  end

  def serializer
    @serializer ||= Redistry::Serializers::ActiveRecord.new
  end
end

ActiveRecord::Base.send(:include, Redistry::HasList) if defined?(ActiveRecord)
