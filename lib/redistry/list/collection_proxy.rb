module Redistry
  module List
    class CollectionProxy
      attr_reader :klass, :collection_name, :options, :serializer
      
      def initialize(klass, collection_name, options = {})
        @klass = klass
        @collection_name = collection_name
        @options = default_options.merge(options)

        setup_serializer!
      end

      def all
        serialized_objs = Redistry.client.lrange(key,0,-1)
        serialized_objs.nil? || serialized_objs.empty? ? [] : @serializer.deserialize(klass, serialized_objs)
      end

      def add(*objs)
        serialized_objs = @serializer.serialize(klass, objs.flatten)
        serialized_objs.reverse.each do |val|
          Redistry.client.lpush(key, val)
        end

        if options[:size]
          Redistry.client.ltrim(key,0,options[:size]-1)
        end
        self
      end

      def clear
        Redistry.client.del(key)
        self
      end

      def key
        @key ||= "#{klass.name}-#{collection_name.to_s}"
      end

      private

      def default_options
        { 
          :serializer => nil,
          :size       => nil
        }
      end

      def setup_serializer!
        @serializer = case options[:serializer]
          when :activerecord
            Redistry::Serializers::ActiveRecord.new
          when :json
            Redistry::Serializers::JSON.new
          else
            default_serializer
          end
      end

      def default_serializer
        if Redistry.loaded_frameworks.include?(:activerecord) &&
           klass < ActiveRecord::Base
          Redistry::Serializers::ActiveRecord.new
        else
          Redistry::Serializers::JSON.new
        end
      end
    end
  end
end
