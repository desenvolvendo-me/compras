module ActiveRecord
  module Filters
    class Filter
      include ActiveRecord::Filters::Base

      attr_accessor :klass
      attr_accessor :attributes
      attr_accessor :options

      def initialize(klass, attributes, options)
        self.klass      = klass
        self.attributes = attributes
        self.options    = options
      end

      def call(params)
        relation = scoped

        columns.inject(relation) do |relation, column|
          # TODO: have a better way to compare this?
          param = if association? && relation.arel_table != column.relation
            key = "#{association.name}_attributes"
            params[key][column.name] if params[key]
          else
            params[column.name]
          end

          next relation if param.blank?

          case column
          when Arel::Attributes::String
            relation.where(column.matches("#{param}%"))
          when Arel::Attributes::Decimal, Arel::Attributes::Float, Arel::Attributes::Integer
            relation.where(column.eq(I18n::Alchemy::NumericParser.parse(param)))
          when Arel::Attributes::Time
            # TODO: why arel uses arel/attributes/time for date columns?
            relation.where(column.eq(I18n::Alchemy::DateParser.parse(param)))
          else
            relation.where(column.eq(param))
          end
        end
      end

      protected

      def columns
        @columns ||= begin
          columns = attributes.map do |attribute|
            find_column(klass, attribute)
          end

          if association
            columns += association.klass.accessible_attributes.map do |attribute|
              find_column(association.klass, attribute)
            end
          end

          columns.compact
        end
      end
    end
  end
end
