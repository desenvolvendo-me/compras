class PurchaseFormDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name,:expense

  def opening_balance
    number_with_precision super if super
  end

end
