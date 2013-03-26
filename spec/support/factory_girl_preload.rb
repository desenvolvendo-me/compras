module FactoryGirl
  module Preload
    def self.clean(*names)
      query = case ActiveRecord::Base.connection.adapter_name
              when "SQLite"     then "DELETE FROM %s"
              when "PostgreSQL" then "TRUNCATE TABLE %s CASCADE"
              else "TRUNCATE TABLE %s"
              end

      names = ActiveRecord::Base.descendants.collect(&:table_name).compact if names.empty?

      ActiveRecord::Base.connection.disable_referential_integrity do
        names.each {|table| ActiveRecord::Base.connection.execute(query % ActiveRecord::Base.connection.quote_table_name(table))}
      end
    end
  end
end
