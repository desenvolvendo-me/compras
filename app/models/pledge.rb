class Pledge < Compras::Model
  attr_modal :code, :descriptor_id, :emission_date, :management_unit_id,
             :budget_allocation_id, :creditor_id

  belongs_to :descriptor
  belongs_to :creditor
  belongs_to :reserve_fund
  belongs_to :management_unit
  belongs_to :budget_allocation
  belongs_to :pledge_category
  belongs_to :pledge_historic
  belongs_to :contract
  belongs_to :founded_debt_contract, :class_name => 'Contract'
  belongs_to :licitation_modality
  belongs_to :licitation_process
  belongs_to :expense_nature

  has_many :pledge_items, :dependent => :destroy, :inverse_of => :pledge, :order => :id

  def to_s
     "#{code} - #{entity}/#{year}"
  end
end
