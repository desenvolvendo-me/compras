class LicitationProcessLot < ActiveRecord::Base
  attr_accessible :observations, :administrative_process_budget_allocation_item_ids

  belongs_to :licitation_process

  has_many :administrative_process_budget_allocation_items, :dependent => :nullify, :order => :id

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
end
