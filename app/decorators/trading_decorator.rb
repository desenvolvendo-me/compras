class TradingDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :code_and_year, :created_at_date, :licitation_process, :licitating_unit,
              :summarized_object

  def licitation_process_id
    super || -1
  end

  def created_at_date
    created_at.to_date
  end
end
