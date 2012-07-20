class BudgetAllocationDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def real_amount
    number_with_precision(super) if super
  end

  def reserved_value
    number_with_precision(super) if super
  end
end
