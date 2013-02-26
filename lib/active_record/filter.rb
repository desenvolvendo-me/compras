module ActiveRecord
  module Filter
    extend ActiveSupport::Concern

    module ClassMethods
      def filterize(attributes = accessible_attributes, options = {})
        attributes, options = accessible_attributes, attributes if attributes.is_a?(Hash)

        scope :filter, Filters::Filter.new(self, attributes, options)
      end

      def orderize(*attributes)
        if attributes.empty?
          attributes = [:name]
        elsif attributes.last.is_a? Hash
          include_table = attributes.last.fetch(:on)
          table_name = include_table.to_s.classify.constantize.table_name
          attributes = "#{table_name}.#{attributes.first}" if include_table.present?
        end

        scope :ordered, order(*attributes).joins(include_table)
      end
    end
  end
end
