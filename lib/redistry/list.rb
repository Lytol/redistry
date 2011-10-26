require 'redistry/list/collection_proxy'

module Redistry
  module List

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      
      def has_list(name, options = {})
        klass = options.delete(:class) || self

        define_method name do
          return instance_variable_get("@_#{name}_has_list") if instance_variable_get("@_#{name}_has_list")

          raise("`#{klass.name}` must have an unique `id` for each object to use `has_list`") unless respond_to?(:id)
          instance_variable_set("@_#{name}_has_list", CollectionProxy.new(klass, "#{name}-#{id}", options))
        end
      end

      def list(name, options = {})
        klass = options.delete(:class) || self

        instance_variable_set("@_#{name}_list".to_sym, CollectionProxy.new(klass, name, options))
        class_eval <<-EOF
          def self.#{name}
            @_#{name}_list
          end
        EOF
      end
    end
  end
end
