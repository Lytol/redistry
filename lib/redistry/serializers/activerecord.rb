module Redistry
  module Serializers
    class ActiveRecord
      def serialize(klass, *objs)
        objs.flatten.map(&:id)
      end

      def deserialize(klass, *objs)
        ids = objs.flatten
        ar_objects = klass.find(objs.flatten).inject({}) { |h,o| h[o.id.to_s] = o; h }
        ids.map { |i| ar_objects[i.to_s] }
      end
    end
  end
end
