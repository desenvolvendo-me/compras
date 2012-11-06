class ReserveFund < Compras::Model
  attr_modal :date, :licitation_modality_id, :creditor_id, :status,
             :descriptor_id, :budget_allocation_id

  has_enumeration_for :status, :with => ReserveFundStatus, :create_helpers => true

  belongs_to :licitation_process
  belongs_to :descriptor
  belongs_to :budget_allocation
  belongs_to :licitation_modality
  belongs_to :creditor

  delegate :real_amount, :amount, :function, :subfunction, :government_program, :government_action, :budget_structure,
           :expense_nature, :reserved_value, :to => :budget_allocation, :allow_nil => true, :prefix => true
  delegate :expense_category_id, :to => :budget_allocation, :allow_nil => true
  delegate :expense_group_id, :to => :budget_allocation, :allow_nil => true
  delegate :expense_modality_id, :to => :budget_allocation, :allow_nil => true
  delegate :expense_element_id, :to => :budget_allocation, :allow_nil => true
  delegate :expense_nature_expense_nature, :to => :budget_allocation, :allow_nil => true
  delegate :year, :to => :descriptor, :allow_nil => true
  delegate :administrative_process, :to => :licitation_process, :allow_nil => true

  orderize :id
  filterize

  def to_s
    "#{id}/#{year}"
  end
end
