class PurchaseProcessClassificationBiddersVerifier
  attr_accessor :purchase_process

  delegate :bidders, :to => :purchase_process, :allow_nil => true

  def initialize(purchase_process)
    self.purchase_process = purchase_process
  end

  def verify!
    bidders.each do |bidder|
      disable_bidder_by_documentation_problem(bidder)
      disable_bidder_by_maximum_value(bidder) if validate_bidder_by_maximum_value?(bidder)
    end
  end

  private

  def validate_bidder_by_maximum_value?(bidder)
    bidder.enabled.nil? || bidder.enabled?
  end

  def disable_bidder_by_documentation_problem(bidder)
    if bidder.has_documentation_problem?
      bidder.inactivate! unless bidder.benefited_by_law_of_proposals?
    else
      bidder.activate!
    end
  end

  def disable_bidder_by_maximum_value(bidder)
    if bidder.has_proposals_unit_price_greater_than_budget_allocation_item_unit_price?
      bidder.inactivate!
    end
  end
end
