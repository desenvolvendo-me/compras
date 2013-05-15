# encoding: utf-8
class PurchaseProcessClassificationGenerator
  attr_accessor :purchase_process, :classification_repository, :proposal_repository

  delegate :judgment_form, :bidders, :items,
           :all_licitation_process_classifications,
           :to => :purchase_process, :allow_nil => true

  def initialize(purchase_process,
    classification_repository = LicitationProcessClassification,
    proposal_repository = BidderProposal)
    self.purchase_process = purchase_process
    self.classification_repository = classification_repository
    self.proposal_repository = proposal_repository
  end

  def generate!
    purchase_process.destroy_all_licitation_process_classifications

    if judgment_form.lowest_price? && judgment_form.item?
      lowest_price_by_item
    elsif judgment_form.lowest_price? && judgment_form.global?
      lowest_global_price
    elsif judgment_form.lowest_price? && judgment_form.lot?
      lowest_price_by_lot
    else
      puts "impossible generate classification for judgment kind: #{judgment_form.kind} and judgment licitation kind #{judgment_form.licitation_kind}"
    end
  end

  protected

  def lowest_price_by_item
    items.each do |item|
      proposals = proposal_repository.by_item_order_by_unit_price(item.id)
      ordered_proposals = proposals.reject { |proposal| proposal.unit_price <= 0 }

      proposals.each do |proposal|
        classification_repository.create!(
          :unit_value => proposal.unit_price,
          :total_value => proposal.total_price,
          :classification => classify_item(proposal, ordered_proposals),
          :bidder => proposal.bidder,
          :classifiable => proposal.purchase_process_item
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

  def classify_item(item, ordered_items)
    item_index = ordered_items.index(item)

    item_index.nil? ? -1 : item_index.succ
  end
end
