class LicitationProcessRatificationItem < Compras::Model
  attr_accessible :licitation_process_ratification_id, :purchase_process_creditor_proposal_id,
    :ratificated

  belongs_to :licitation_process_ratification
  belongs_to :purchase_process_creditor_proposal

  has_one :licitation_process, through: :purchase_process_creditor_proposal
  has_one :item, through: :purchase_process_creditor_proposal
  has_one :creditor, through: :purchase_process_creditor_proposal
  has_one :material, through: :item

  delegate :quantity, to: :item, allow_nil: true
  delegate :description, :code, :reference_unit, to: :material, allow_nil: true
  delegate :identity_document, to: :creditor, allow_nil: true, prefix: true
  delegate :unit_price, :total_price, :lot, :item,
    to: :purchase_process_creditor_proposal, allow_nil: true
  delegate :execution_unit_responsible, :year, :process,
    to: :licitation_process, allow_nil: true, prefix: true

  orderize "id DESC"
  filterize
end
