require 'json'

module Redistry
  module Serializers
    class JSON
      def serialize(klass, *objs)
        objs.flatten.map { |o| o.to_json }
      end

      def deserialize(klass, *objs)
        objs.flatten.map { |o| ::JSON.parse(o) }
      end
    end
  end
end
