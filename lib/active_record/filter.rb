module ActiveRecord
  module Filter
    extend ActiveSupport::Concern

    module ClassMethods
      def filterize(attributes = accessible_attributes, options = {})
        attributes, options = accessible_attributes, attributes if attributes.is_a?(Hash)

        scope :filter, Filters::Filter.new(self, attributes, options)
      end

      def orderize(*attributes)
        attributes = [:name] if attributes.empty?

        scope :ordered, order(*attributes)
      end
    end
  end
end
