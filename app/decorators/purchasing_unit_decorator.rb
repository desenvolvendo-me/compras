class PurchasingUnitDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header  :name,:code,:cnpj,:starting,:situation, :billing

end
