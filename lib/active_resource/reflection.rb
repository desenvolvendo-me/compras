module ActiveResource
  module Reflection
    extend ActiveSupport::Concern

    included do
      class_attribute :reflections
      self.reflections = {}
    end

    module ClassMethods
      def create_reflection(macro, name, options, active_resource)
        if macro == :belongs_to
          reflection = BelongsToReflection.new(name, options, active_resource)
        else
          raise "Invalid reflection macro '#{macro}'"
        end

        if reflection
          self.reflections = reflections.merge(name.to_s => reflection)
        end

        reflection
      end

      def reflect_on_association(name)
        reflections[name.to_s]
      end

      def reflect_on_all_associations(macro = nil)
        reflections.values
      end
    end

    class BelongsToReflection
      attr_reader :name, :klass, :foreign_key

      def initialize(name, options, active_resource)
        @name = name.to_s
        @resource_class = active_resource
        @foreign_key = options.fetch(:foreign_key) { "#{name}_id" }
        @options = options
      end

      def class_name
        @name.camelize
      end

      def association_class
        self.class
      end

      def klass
        options.fetch(:class_name) { class_name.constantize }
      end

      def options
        @options.tap do |configs|
          configs[:order] = configs.fetch(:order, :id)
        end
      end

      def macro
        :belongs_to
      end

      private

      attr_reader :resource_class
    end
  end
end
