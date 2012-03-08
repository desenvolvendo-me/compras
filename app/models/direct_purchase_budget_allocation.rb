class DirectPurchaseBudgetAllocation < ActiveRecord::Base
  attr_accessible :direct_purchase_id, :budget_allocation_id, :pledge_type, :items_attributes

  has_enumeration_for :pledge_type, :with => DirectPurchaseBudgetAllocationPledgeType

  belongs_to :direct_purchase
  belongs_to :budget_allocation

  has_many :items, :class_name => 'DirectPurchaseBudgetAllocationItem', :dependent => :destroy, :inverse_of => :direct_purchase_budget_allocation

  accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true

  delegate :expense_economic_classification, :amount, :to => :budget_allocation, :allow_nil => true
end
