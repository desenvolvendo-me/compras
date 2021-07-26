class IndexerDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :currency

  def summary
    currency
  end
end
