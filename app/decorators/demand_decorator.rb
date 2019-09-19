class DemandDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :year, :name, :status, :initial_date, :final_date
end
