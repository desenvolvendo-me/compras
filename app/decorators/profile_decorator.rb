class ProfileDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name

  def creditor_name
    "Fornecedor"
  end
end
