class LicitationProcessBidderProposalDecorator < Decorator
  def unit_price
    helpers.number_to_currency(component.unit_price, :format => "%n")
  end

  def total_price
    helpers.number_to_currency(component.total_price, :format => "%n")
  end
end
