class RealigmentPrice < Compras::Model
  attr_accessible :price, :purchase_process_item, :purchase_process_item_id, :proposal,
                  :brand, :delivery_date, :quantity, :proposal_id

  belongs_to :proposal, class_name: 'PurchaseProcessCreditorProposal', :foreign_key => 'purchase_process_creditor_proposal_id'
  belongs_to :purchase_process_item

  validates :price, presence: true

  orderize :id
end
