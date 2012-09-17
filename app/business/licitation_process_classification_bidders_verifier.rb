class LicitationProcessClassificationBiddersVerifier
  attr_accessor :licitation_process

  delegate :bidders, :consider_law_of_proposals,
           :disqualify_by_documentation_problem, :disqualify_by_maximum_value,
           :to => :licitation_process, :allow_nil => true

  def initialize(licitation_process)
    self.licitation_process = licitation_process
  end

  def verify!
    disable_bidders_by_documentation_problem!

    disable_bidders_by_maximum_value!
  end

  protected

  def disable_bidders_by_documentation_problem!
    return unless disqualify_by_documentation_problem

    bidders.each do |bidder|
      if !bidder.filled_documents? || bidder.expired_documents?
        if (consider_law_of_proposals && !bidder.benefited) || !consider_law_of_proposals
          bidder.inactive!
        end
      else
        unless bidder.benefited
          bidder.active!
        end
      end

      bidder.save!
    end
  end

  def disable_bidders_by_maximum_value!
    return unless disqualify_by_maximum_value

    bidders.each do |bidder|
      if bidder.has_proposals_unit_price_greater_than_budget_allocation_item_unit_price?
        bidder.inactive!
        bidder.save!
      end
    end
  end
end
