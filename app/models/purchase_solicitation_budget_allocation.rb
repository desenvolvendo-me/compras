class PurchaseSolicitationBudgetAllocation < ActiveRecord::Base
  attr_accessible :purchase_solicitation_id, :budget_allocation_id, :estimated_value, :blocked
  attr_accessible :expense_element_id, :items_attributes

  belongs_to :purchase_solicitation
  belongs_to :budget_allocation
  belongs_to :expense_element

  has_many :items, :class_name => 'PurchaseSolicitationBudgetAllocationItem', :dependent => :destroy, :order => :id

  accepts_nested_attributes_for :items, :allow_destroy => true

  validates :budget_allocation, :estimated_value, :presence => true

  validate :must_have_at_least_one_item

  def total_items_value
    items.collect(&:estimated_total_price).sum
  end

  protected

  def must_have_at_least_one_item
    if items.reject(&:marked_for_destruction?).empty?
      errors.add(:items, :must_have_at_least_one_item)
    end
  end
end
