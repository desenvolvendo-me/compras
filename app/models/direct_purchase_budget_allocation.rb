class DirectPurchaseBudgetAllocation < ActiveRecord::Base
  attr_accessible :direct_purchase_id, :budget_allocation_id, :pledge_type, :items_attributes

  has_enumeration_for :pledge_type, :with => DirectPurchaseBudgetAllocationPledgeType

  belongs_to :direct_purchase
  belongs_to :budget_allocation

  has_many :items, :class_name => 'DirectPurchaseBudgetAllocationItem', :dependent => :destroy, :order => :id

  accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true

  delegate :expense_economic_classification, :amount, :to => :budget_allocation, :allow_nil => true
  delegate :licitation_object_id, :to => :direct_purchase, :allow_nil => true

  validates :budget_allocation, :pledge_type, :presence => true
  validate :must_have_at_least_one_item

  def total_items_value
    items.collect(&:estimated_total_price).sum
  end

  protected

  def must_have_at_least_one_item
    return unless items.empty?

    errors.add(:items)
    items.build.valid?
  end
end
