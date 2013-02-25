class LicitationProcessLot < Compras::Model
  attr_accessible :observations, :administrative_process_budget_allocation_item_ids, :licitation_process_id

  belongs_to :licitation_process

  has_many :administrative_process_budget_allocation_items, :dependent => :nullify, :order => :id
  has_many :bidder_proposals, :through => :administrative_process_budget_allocation_items
  has_many :bidders, :through => :bidder_proposals
  has_many :licitation_process_classifications, :as => :classifiable, :dependent => :destroy

  delegate :administrative_process, :administrative_process_id,
           :type_of_calculation, :to => :licitation_process, :allow_nil => true
  delegate :updatable?, :to => :licitation_process, :prefix => true,
           :allow_nil => true

  validate :administrative_process_budget_allocation_items_should_have_at_least_one
  validate :items_should_belong_to_administrative_process

  orderize "id DESC"
  filterize

  scope :licitation_process_less_than_me, lambda { |licitation_process_id, id|
    where { |lot| lot.licitation_process_id.eq(licitation_process_id) & lot.id.lteq(id) }
  }

  def to_s
    "Lote #{count_lots}"
  end

  def order_bidders_by_total_price
    bidders.sort { |a,b| a.proposal_total_value_by_lot(self) <=> b.proposal_total_value_by_lot(self) }
  end

  def items_should_belong_to_administrative_process
    administrative_process_budget_allocation_items.each do |item|
      if item.administrative_process_id != administrative_process.id
        errors.add(:administrative_process_budget_allocation_items, :item_is_not_from_correct_administrative_process, :administrative_process => administrative_process)
      end
    end
  end

  def count_lots
    self.class.licitation_process_less_than_me(licitation_process_id, id).count
  end

  def winning_bid
    licitation_process_classifications.detect { |classification| classification.situation == SituationOfProposal::WON }
  end

  private

  def administrative_process_budget_allocation_items_should_have_at_least_one
    if administrative_process_budget_allocation_items.empty?
      errors.add :administrative_process_budget_allocation_items, :should_be_at_least_one_item
    end
  end
end
