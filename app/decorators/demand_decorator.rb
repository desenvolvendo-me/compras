class DemandDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :year, :name_id, :status, :initial_date, :final_date, :link => [:year, :name_number]

  def name_id
    (name) +" / "+ id.to_s
  end
end
