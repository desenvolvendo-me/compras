module FactoryGirl
  module Preload
    def self.clean(*names)
      names = [
        'unico_countries',
        'unico_states',
        'unico_cities',
        'unico_districts',
        'unico_neighborhoods',
        'unico_customers'
      ].join(", ")

      query = "TRUNCATE %s CASCADE" % names

      ActiveRecord::Base.connection.disable_referential_integrity do
        ActiveRecord::Base.connection.execute(query)
      end
    end
  end
end
