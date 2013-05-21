class RealigmentPrice < Compras::Model
  attr_accessible :price, :purchase_process_item, :purchase_process_item_id, :purchase_process_creditor_proposal,
                  :brand, :delivery_date, :quantity

  belongs_to :proposal, class_name: 'PurchaseProcessCreditorProposal'
  belongs_to :purchase_process_item

  delegate :brand, :lot, :creditor, :creditor_id, :licitation_process_id, :licitation_process, :delivery_date,
           to: :proposal, allow_nil: true
  delegate :items, to: :licitation_process, allow_nil: true

  validates :price, presence: true

  orderize :id
end
