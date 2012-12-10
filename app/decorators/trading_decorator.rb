class TradingDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :created_at, :licitation_process, :licitating_unit,
              :administrative_process_summarized_object

  def licitation_process_id
    super || -1
  end

  def created_at
    super.to_date
  end
end
