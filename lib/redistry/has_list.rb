require 'redistry/has_list/collection_proxy'

module Redistry
  module HasList

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      
      def has_list(name, options = {})
        klass = options.delete(:class) || self
        instance_variable_set("@_#{name}_has_list".to_sym, CollectionProxy.new(klass, name, options))

        class_eval <<-EOF
          def self.#{name}
            @_#{name}_has_list
          end
        EOF
      end
    end
  end
end
