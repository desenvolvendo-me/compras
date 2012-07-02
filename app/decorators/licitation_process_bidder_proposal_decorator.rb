class LicitationProcessBidderProposalDecorator < Decorator
  def unit_price
    helpers.number_to_currency(super, :format => "%n")
  end

  def total_price
    helpers.number_to_currency(super, :format => "%n")
  end
end
