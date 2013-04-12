class PurchaseProcessCreditorProposal < Compras::Model
  attr_accessible :creditor_id, :administrative_process_budget_allocation_item_id,
                  :brand, :unit_price, :item, :creditor

  belongs_to :creditor
  belongs_to :item, class_name: 'AdministrativeProcessBudgetAllocationItem',
    foreign_key: :administrative_process_budget_allocation_item_id

  has_one :licitation_process, through: :item

  delegate :lot, :additional_information, :quantity, :reference_unit, :material,
    to: :item, allow_nil: true, prefix: true

  validates :creditor, :item, :brand, :unit_price, presence: true

  def total_price
    unit_price * item_quantity
  end
end
