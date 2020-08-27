ActiveSupport.on_load(:active_record) do
  module ActiveRecord
    module ConnectionAdapters
      class PostgreSQLAdapter < AbstractAdapter
        module SchemaStatements
          remove_method :change_column

          def change_column(table_name, column_name, type, options = {})
            quoted_table_name, quoted_column_name = quote_table_name(table_name), quote_column_name(column_name)

            sql = "ALTER TABLE #{quoted_table_name} ALTER COLUMN #{quoted_column_name} TYPE #{type_to_sql(type, options[:limit], options[:precision], options[:scale])}"

            sql << " USING CAST(#{quoted_column_name} AS INTEGER)" if type == :integer
            sql << " USING CAST(#{quoted_column_name} AS DECIMAL)" if type == :decimal

            execute sql

            change_column_default(table_name, column_name, options[:default]) if options_include_default?(options)
            change_column_null(table_name, column_name, options[:null], options[:default]) if options.key?(:null)
          end
        end
      end

      class AbstractAdapter
        remove_method :disable_referential_integrity

        def disable_referential_integrity(&block)
          block.call
        end
      end
    end
  end
end
