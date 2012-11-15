class AdministrativeProcessBudgetAllocation < Compras::Model
  attr_accessible :administrative_process_id, :budget_allocation_id, :value,
                  :items_attributes

  attr_modal :material, :quantity, :unit_price

  belongs_to :administrative_process
  belongs_to :budget_allocation

  has_many :items, :class_name => 'AdministrativeProcessBudgetAllocationItem',
           :dependent => :destroy, :order => :id

  accepts_nested_attributes_for :items, :allow_destroy => true

  delegate :expense_nature, :amount,
           :to => :budget_allocation, :allow_nil => true, :prefix => true
  delegate :type_of_calculation,
           :to => :administrative_process, :allow_nil => true

  validates :budget_allocation, :value, :presence => true
  validates :items, :no_duplication => :material_id

  def total_items_value
    items.reject(&:marked_for_destruction?).sum(&:estimated_total_price)
  end
end
