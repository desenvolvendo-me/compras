class TradingDecorator
  include Decore
  include Decore::Proxy

  def licitation_process_id
    super || -1
  end
end
