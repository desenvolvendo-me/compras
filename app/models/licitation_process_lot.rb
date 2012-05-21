class LicitationProcessLot < ActiveRecord::Base
  attr_accessible :observations, :administrative_process_budget_allocation_item_ids

  belongs_to :licitation_process

  has_many :administrative_process_budget_allocation_items, :dependent => :nullify, :order => :id
  has_many :licitation_process_bidder_proposals, :through => :administrative_process_budget_allocation_items
  has_many :licitation_process_bidders, :through => :licitation_process_bidder_proposals

  delegate :administrative_process_id, :to => :licitation_process, :allow_nil => true
  delegate :type_of_calculation, :to => :licitation_process, :allow_nil => true

  validate :items_should_belong_to_administrative_process

  orderize :id
  filterize

  def to_s
    "Lote #{count_lots}"
  end

  def items_should_belong_to_administrative_process
    administrative_process_budget_allocation_items.each do |item|
      if item.administrative_process_id != administrative_process_id
        errors.add(:administrative_process_budget_allocation_items, :item_is_not_from_correct_administrative_process)
      end
    end
  end

  def winner_proposals(classificator = LicitationProcessProposalsClassificatorByLot)
    classificator.new(self, type_of_calculation).winner_proposals
  end

  def count_lots
    self.class.where { |lot| lot.id.lteq id }.count
  end
end
