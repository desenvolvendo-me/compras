class PledgeRequest < Compras::Model
  include BelongsToResource

  attr_accessible :descriptor_id, :budget_allocation_id, :expense_nature_id,
                  :accounting_account_id, :contract_id, :reserve_fund_id, :purchase_process_id,
                  :creditor_id, :amount, :emission_date,
                  :items_attributes, :purchase_solicitation_id,
                  :budget_allocation, :expense_id, :purchase_form_id

  belongs_to :purchase_process, class_name: 'LicitationProcess' #TODO: Usar o nome do modal original
  belongs_to :contract
  belongs_to :creditor
  belongs_to :expense
  belongs_to :purchase_solicitation
  belongs_to :purchase_form

  belongs_to_resource :descriptor
  belongs_to_resource :accounting_account
  belongs_to_resource :expense_nature
  belongs_to_resource :reserve_fund

  delegate :amount, to: :reserve_fund, allow_nil: true, prefix: true
  delegate :budget_allocations_ids, to: :purchase_process, allow_nil: true, prefix: true

  validates_presence_of :purchase_process, :purchase_solicitation, :purchase_form

  orderize :id
  filterize

  scope :by_purchase_process_id, ->(purchase_process_id) do
    where {|query| query.purchase_process_id.eq(purchase_process_id)}
  end

  def to_s
    "#{self.contract.creditor unless self.contract.nil? || self.contract.creditor.blank? } - #{purchase_process}"
  end

end
