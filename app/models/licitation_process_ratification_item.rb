class LicitationProcessRatificationItem < Compras::Model
  attr_accessible :licitation_process_ratification_id, :purchase_process_creditor_proposal_id,
    :ratificated, :purchase_process_item_id

  belongs_to :licitation_process_ratification
  belongs_to :purchase_process_creditor_proposal
  belongs_to :purchase_process_item

  has_one :licitation_process, through: :purchase_process_creditor_proposal
  has_one :item, through: :purchase_process_creditor_proposal
  has_one :creditor, through: :licitation_process_ratification

  delegate :description, :code, :reference_unit, to: :material, allow_nil: true
  delegate :identity_document, to: :creditor, allow_nil: true, prefix: true
  delegate :unit_price, :total_price, :lot,
    to: :purchase_process_creditor_proposal, allow_nil: true
  delegate :execution_unit_responsible, :year, :process,
    to: :licitation_process, allow_nil: true, prefix: true

  def material
    item.try(:material) || purchase_process_item.try(:material)
  end

  def quantity
    item.try(:quantity) || purchase_process_item.try(:quantity)
  end

  def unit_price
    purchase_process_creditor_proposal.try(:unit_price) || purchase_process_item.try(:unit_price)
  end

  def total_price
    purchase_process_creditor_proposal.try(:total_price) || purchase_process_item.try(:estimated_total_price)
  end

  def lot
    purchase_process_creditor_proposal.try(:lot) || purchase_process_item.try(:lot)
  end

  orderize "id DESC"
  filterize
end
