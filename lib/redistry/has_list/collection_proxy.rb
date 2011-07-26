module Redistry
  module HasList
    class CollectionProxy < Array
      attr_accessor :klass, :collection_name, :options
      
      def initialize(klass, collection_name, options = {})
        self.klass = klass
        self.collection_name = collection_name
        self.options = default_options.merge(options)
      end

      def key
        @key ||= "#{klass.name}-#{collection_name.to_s}"
      end

      def all
        serialized_objs = Redistry.client.lrange(key,0,-1)
        Redistry.serializer.deserialize(klass, serialized_objs)
      end

      def add(*objs)
        serialized_objs = Redistry.serializer.serialize(klass, objs.flatten)
        serialized_objs.each do |val|
          Redistry.client.lpush(key, val)
        end

        if options[:size]
          Redistry.client.ltrim(key,0,options[:size]-1)
        end
      end

      def clear
        Redistry.client.del(key)
      end

      private

        def default_options
          {
            :size => nil
          }
        end
    end
  end
end
