class LicitationProcessBudgetAllocation < ActiveRecord::Base
  attr_accessible :licitation_process_id, :budget_allocation_id, :estimated_value, :pledge_type, :items_attributes

  has_enumeration_for :pledge_type

  belongs_to :licitation_process
  belongs_to :budget_allocation

  has_many :items, :class_name => 'LicitationProcessBudgetAllocationItem', :dependent => :destroy, :order => :id

  accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true

  delegate :expense_economic_classification, :amount, :to => :budget_allocation, :allow_nil => true

  validates :budget_allocation, :estimated_value, :pledge_type, :presence => true
end
