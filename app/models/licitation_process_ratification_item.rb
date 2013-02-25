class LicitationProcessRatificationItem < Compras::Model
  attr_accessible :licitation_process_ratification_id, :bidder_proposal_id, :ratificated

  belongs_to :licitation_process_ratification
  belongs_to :bidder_proposal

  delegate :description, :code, :reference_unit, :to => :bidder_proposal, :allow_nil => true
  delegate :quantity, :unit_price, :total_price, :to => :bidder_proposal, :allow_nil => true

  orderize "id DESC"
  filterize
end
