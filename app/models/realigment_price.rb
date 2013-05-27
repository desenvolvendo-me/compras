class RealigmentPrice < Compras::Model
  attr_accessible :price, :item, :purchase_process_item_id,
                  :proposal, :brand, :delivery_date, :quantity, :proposal_id

  belongs_to :proposal, class_name: 'PurchaseProcessCreditorProposal',
    foreign_key: :purchase_process_creditor_proposal_id
  belongs_to :item, class_name: 'PurchaseProcessItem',
    foreign_key: :purchase_process_item_id

  has_one :licitation_process, through: :proposal
  has_one :creditor, through: :proposal
  has_one :material, through: :item

  validates :price, presence: true

  delegate :lot, to: :proposal, allow_nil: true, prefix: false
  delegate :execution_unit_responsible, :year, :process,
    to: :licitation_process, allow_nil: true, prefix: true
  delegate :name, :cnpj, :benefited, :identity_document,
    to: :creditor, allow_nil: true, prefix: true
  delegate :code, :description, :reference_unit,
    to: :material, prefix: true, allow_nil: true

  orderize :id
end
