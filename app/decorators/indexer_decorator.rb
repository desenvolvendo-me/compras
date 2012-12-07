class IndexerDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :currency, :to_s => false, :link => :name

  def summary
    currency
  end
end
