class ReserveFundDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def budget_allocation_real_amount
    number_with_precision super if super
  end
end
