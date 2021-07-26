module ActiveRecord
  module Modal
    extend ActiveSupport::Concern

    included do
      class_attribute :_modal_attributes
    end

    module ClassMethods
      def attr_modal(*attributes)
        self._modal_attributes = Set.new(attributes.map { |a| a.to_s }) + (self._modal_attributes || [])
      end

      def modal_attributes
        self._modal_attributes || accessible_attributes.to_set
      end
    end
  end
end
