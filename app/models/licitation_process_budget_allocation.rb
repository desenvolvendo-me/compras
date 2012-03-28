class LicitationProcessBudgetAllocation < ActiveRecord::Base
  attr_accessible :licitation_process_id, :budget_allocation_id, :estimated_value, :pledge_type, :items_attributes

  has_enumeration_for :pledge_type

  belongs_to :licitation_process
  belongs_to :budget_allocation

  has_many :items, :class_name => 'LicitationProcessBudgetAllocationItem', :dependent => :destroy, :order => :id

  accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true

  delegate :expense_economic_classification, :amount, :to => :budget_allocation, :allow_nil => true

  validates :budget_allocation, :estimated_value, :pledge_type, :presence => true

  validate :cannot_have_duplicated_materials_on_items

  protected

  def cannot_have_duplicated_materials_on_items
    single_materials = []

    items.each do |item|
      if single_materials.include?(item.material_id)
        errors.add(:items)
        item.errors.add(:material_id, :taken)
      end
      single_materials << item.material_id
    end
  end
end
