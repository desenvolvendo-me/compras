class AdministrativeProcessBudgetAllocation < ActiveRecord::Base
  attr_accessible :administrative_process_id, :budget_allocation_id, :value, :items_attributes

  belongs_to :administrative_process
  belongs_to :budget_allocation

  has_many :items, :class_name => 'AdministrativeProcessBudgetAllocationItem', :dependent => :destroy, :order => :id

  accepts_nested_attributes_for :items, :allow_destroy => true

  delegate :expense_nature, :amount, :to => :budget_allocation, :allow_nil => true, :prefix => true

  validates :budget_allocation, :value, :presence => true

  validate :cannot_have_duplicated_materials_on_items

  def attributes_for_data
    { 'id' => id,
      'description' => budget_allocation.to_s,
      'budget_allocation_id' => budget_allocation_id,
      'value' => value.to_f,
      'expense_nature' => budget_allocation_expense_nature.to_s,
      'amount' => budget_allocation_amount.to_f }
  end

  def total_items_value
    items.reject(&:marked_for_destruction?).sum(&:estimated_total_price)
  end

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
