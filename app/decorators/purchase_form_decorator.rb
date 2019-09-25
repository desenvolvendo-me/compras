class PurchaseFormDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper

  attr_header :name,:budget_allocation,:opening_balance

  def opening_balance
    number_with_precision super if super
  end

end
