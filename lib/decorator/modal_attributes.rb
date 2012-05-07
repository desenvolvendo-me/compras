class Decorator < ActiveSupport::BasicObject
  module ModalAttributes

    def modal_attributes
      decorator_class.modal_attributes || component.class.accessible_attributes.to_set
    end

    module ClassMethods
      attr_accessor :_modal_attributes

      def attr_modal(*attributes)
        self._modal_attributes = Set.new(attributes.map { |a| a.to_s }) + (_modal_attributes || [])
      end

      def modal_attributes
        _modal_attributes
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
