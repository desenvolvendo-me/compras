class LicitationProcessRatificationItem < Compras::Model
  attr_accessible :licitation_process_ratification_id, :purchase_process_creditor_proposal_id,
    :ratificated, :purchase_process_item_id

  belongs_to :licitation_process_ratification
  belongs_to :purchase_process_creditor_proposal
  belongs_to :purchase_process_item

  has_one :licitation_process, through: :purchase_process_creditor_proposal
  has_one :creditor, through: :licitation_process_ratification

  has_many :supply_order_items

  delegate :description, :code, :reference_unit, to: :material, allow_nil: true
  delegate :identity_document, to: :creditor, allow_nil: true, prefix: true
  delegate :unit_price, :total_price,
    to: :purchase_process_creditor_proposal, allow_nil: true
  delegate :execution_unit_responsible, :year, :process,
    to: :licitation_process, allow_nil: true, prefix: true
  delegate :material, :quantity, :lot, to: :item, allow_nil: true

  scope :creditor_id, ->(creditor_id) do
    joins { licitation_process_ratification }.
    where { licitation_process_ratification.creditor_id.eq(creditor_id) }
  end

  scope :licitation_process_id, ->(licitation_process_id) do
    joins { licitation_process_ratification }.
    where { licitation_process_ratification.licitation_process_id.eq(licitation_process_id) }
  end

  def unit_price
    purchase_process_creditor_proposal.try(:unit_price) || purchase_process_item.try(:unit_price)
  end

  def total_price
    purchase_process_creditor_proposal.try(:total_price) || purchase_process_item.try(:estimated_total_price)
  end

  def item
    purchase_process_creditor_proposal.try(:item) || purchase_process_item
  end

  def authorized_quantity
    supply_order_items.sum(:authorization_quantity)
  end

  def supply_order_item_balance
    (quantity || 0) - (authorized_quantity || 0)
  end

  orderize "id DESC"
  filterize
end
