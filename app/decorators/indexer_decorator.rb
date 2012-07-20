class IndexerDecorator
  include Decore
  include Decore::Proxy

  def summary
    currency
  end
end
