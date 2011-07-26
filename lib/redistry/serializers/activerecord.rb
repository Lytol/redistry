module Redistry
  module Serializers
    class ActiveRecord
      def serialize(klass, *objs)
        objs.flatten.map(&:id)
      end

      def deserialize(klass, *objs)
        klass.find(objs.flatten)
      end
    end
  end
end
