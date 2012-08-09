class LicitationProcessRatificationItem < Compras::Model
  attr_accessible :licitation_process_ratification_id, :licitation_process_bidder_proposal_id, :ratificated

  belongs_to :licitation_process_ratification
  belongs_to :licitation_process_bidder_proposal

  delegate :description, :code, :reference_unit, :to => :licitation_process_bidder_proposal, :allow_nil => true
  delegate :quantity, :unit_price, :total_price, :to => :licitation_process_bidder_proposal, :allow_nil => true

  orderize :id
  filterize
end
