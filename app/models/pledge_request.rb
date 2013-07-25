class PledgeRequest < Compras::Model
  include BelongsToResource

  attr_accessible :descriptor_id, :budget_allocation_id, :expense_nature_id,
    :accounting_account_id, :contract_id, :reserve_fund_id, :purchase_process_id,
    :creditor_id, :amount, :historic_complement, :emission_date,
    :items_attributes

  belongs_to :purchase_process, class_name: 'LicitationProcess'
  belongs_to :contract
  belongs_to :creditor

  belongs_to_resource :descriptor
  belongs_to_resource :accounting_account
  belongs_to_resource :budget_allocation
  belongs_to_resource :expense_nature
  belongs_to_resource :reserve_fund

  has_many :items, class_name: 'PledgeRequestItem', inverse_of: :pledge_request,
    dependent: :destroy

  delegate :expense_nature, :balance, to: :budget_allocation, allow_nil: true,
    prefix: true
  delegate :amount, to: :reserve_fund, allow_nil: true, prefix: true
  delegate :budget_allocations_ids, to: :purchase_process, allow_nil: true, prefix: true

  validates :descriptor_id, :budget_allocation_id, :accounting_account_id,
    :contract, :reserve_fund_id, :purchase_process, :creditor, :amount,
    :historic_complement, :emission_date, presence: true

  accepts_nested_attributes_for :items, allow_destroy: true

  orderize :id
  filterize

  def to_s
    "#{creditor} - #{purchase_process}"
  end

  def items_total_value
    items.sum(&:estimated_total_price)
  end

  private

  def budget_allocation_params
    { :methods => [:real_amount, :reserved_value, :balance] }
  end
end
