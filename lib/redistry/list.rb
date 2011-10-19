require 'redistry/list/collection_proxy'

module Redistry
  module List

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def has_list(name, options = {})
        klass = options.delete(:class) || self

        raise("The class `#{klass.name}` must have an unique `id` to use `has_list`") unless klass.instance_methods.include?(:id)

        define_method name do
          return instance_variable_get("@_#{name}_has_list") if instance_variable_get("@_#{name}_has_list")
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
