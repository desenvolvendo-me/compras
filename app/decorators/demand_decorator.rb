class DemandDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :year, :name, :status, :initial_date, :final_date, :link => [:year, :name_number]

  def name
    (super) +" / "+id.to_s
  end
end
