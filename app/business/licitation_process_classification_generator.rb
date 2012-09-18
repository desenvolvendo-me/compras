class LicitationProcessClassificationGenerator
  attr_accessor :licitation_process, :classification_repository, :proposal_repository

  delegate :type_of_calculation, :bidders, :items,
           :all_licitation_process_classifications,
           :to => :licitation_process, :allow_nil => true

  def initialize(licitation_process,
    classification_repository = LicitationProcessClassification,
    proposal_repository = BidderProposal)
    self.licitation_process = licitation_process
    self.classification_repository = classification_repository
    self.proposal_repository = proposal_repository
  end

  def generate!
    licitation_process.destroy_all_licitation_process_classifications

    send(type_of_calculation) if type_of_calculation
  end

  protected

  def lowest_total_price_by_item
    items.each do |item|
      proposals = proposal_repository.by_item_order_by_unit_price(item.id)
      ordered_proposals = proposals.reject { |proposal| proposal.unit_price <= 0 }

      proposals.each do |proposal|
        classification_repository.create!(
          :unit_value => proposal.unit_price,
          :total_value => proposal.total_price,
          :classification => classify_item(proposal, ordered_proposals),
          :bidder => proposal.bidder,
          :classifiable => proposal.administrative_process_budget_allocation_item
        )
      end
    end
  end

  def lowest_global_price
    ordered_bidders = bidders.reject(&:has_item_with_unit_price_equals_zero).
                              sort_by(&:total_price)

    bidders.each do |bidder|
      classification_repository.create!(
        :total_value => bidder.total_price,
        :classification => classify_item(bidder, ordered_bidders),
        :bidder => bidder,
        :classifiable => bidder
      )
    end
  end

  def lowest_price_by_lot
    licitation_process.licitation_process_lots.each do |lot|
      ordered_bidders = lot.order_bidders_by_total_price.
                            reject { |bidder| bidder.has_item_with_unit_price_equals_zero(lot) }

      bidders.each do |bidder|
        classification_repository.create!(
          :total_value => bidder.proposal_total_value_by_lot(lot),
          :classification => classify_item(bidder, ordered_bidders),
          :bidder => bidder,
          :classifiable => lot
        )
      end
    end
  end

  def classify_item(item, ordered_items)
    item_index = ordered_items.index(item)

    item_index.nil? ? -1 : item_index.succ
  end
end
