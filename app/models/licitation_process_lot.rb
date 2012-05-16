class LicitationProcessLot < ActiveRecord::Base
  attr_accessible :observations, :administrative_process_budget_allocation_item_ids

  belongs_to :licitation_process

  has_many :administrative_process_budget_allocation_items, :dependent => :nullify, :order => :id

#  delegate :administrative_process_id, :licitation_process_bidders, :to => :licitation_process, :allow_nil => true
  delegate :administrative_process_id, :to => :licitation_process, :allow_nil => true

  validate :items_should_belong_to_administrative_process

  orderize :id
  filterize

  def to_s
    observations
  end

  def items_should_belong_to_administrative_process
    administrative_process_budget_allocation_items.each do |item|
      if item.administrative_process_id != administrative_process_id
        errors.add(:administrative_process_budget_allocation_items, :item_is_not_from_correct_administrative_process)
      end
    end
  end

  def winner_proposal_provider(bidder_storage = LicitationProcessBidder)
    return unless winner_proposal

    bidder_storage.find(winner_proposal.first).provider
  end

  def winner_proposal_total_price
    return unless winner_proposal

    winner_proposal.last.to_f
  end

  protected

  def winner_proposal
    return unless proposals

    proposals.sort_by {|bidder, value| value.to_f }.first
  end

  def proposals(proposal_storage = LicitationProcessBidderProposal)
    proposal_storage.joins { administrative_process_budget_allocation_item.licitation_process_lot }.
      where{ |lot| lot.licitation_process_lots.id.eq id }.
      group{ [ licitation_process_bidder_proposals.licitation_process_bidder_id ] }.
      sum('administrative_process_budget_allocation_items.quantity * licitation_process_bidder_proposals.unit_price')
  end
end
