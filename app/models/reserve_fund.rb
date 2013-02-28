class ReserveFund < Compras::Model
  attr_modal :date, :modality, :creditor_id, :status,
             :descriptor_id, :budget_allocation_id

  has_enumeration_for :status, :with => ReserveFundStatus, :create_helpers => true
  has_enumeration_for :modality

  belongs_to :licitation_process
  belongs_to :descriptor
  belongs_to :budget_allocation
  belongs_to :creditor

  delegate :real_amount, :amount, :function, :subfunction, :government_program, :government_action, :budget_structure,
           :expense_nature, :reserved_value, :to => :budget_allocation, :allow_nil => true, :prefix => true
  delegate :expense_category_id, :to => :budget_allocation, :allow_nil => true
  delegate :expense_group_id, :to => :budget_allocation, :allow_nil => true
  delegate :expense_modality_id, :to => :budget_allocation, :allow_nil => true
  delegate :expense_element_id, :to => :budget_allocation, :allow_nil => true
  delegate :expense_nature_expense_nature, :to => :budget_allocation, :allow_nil => true
  delegate :year, :to => :descriptor, :allow_nil => true

  orderize "id DESC"
  filterize

  def to_s
    "#{id}/#{year}"
  end
end
