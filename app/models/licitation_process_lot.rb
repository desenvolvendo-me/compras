class LicitationProcessLot < ActiveRecord::Base
  attr_accessible :observations, :administrative_process_budget_allocation_item_ids

  belongs_to :licitation_process

  has_many :administrative_process_budget_allocation_items, :dependent => :nullify, :order => :id

  orderize :id
  filterize

  def to_s
    observations
  end
end
