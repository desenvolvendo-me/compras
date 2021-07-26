module ActiveRecord
  module Filters
    module Base
      def scoped
        @scoped ||= if association
          klass.joins(association.name)
        else
          klass.scoped
        end
      end

      def association
        @association ||= klass.reflect_on_association(options[:using]) if association?
      end

      def association?
        options.key?(:using)
      end

      def find_column(klass, name)
        klass.arel_table.columns.detect{|column| column.name == name.to_sym}
      end
    end
  end
end
