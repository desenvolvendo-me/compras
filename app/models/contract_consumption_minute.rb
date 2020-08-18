class ContractConsumptionMinute < Compras::Model
  attr_accessible :contract_id, :purchase_solicitation_item_id, :contract_quantity, :contract_consumption

  belongs_to :contract
  belongs_to :item, class_name: 'PurchaseSolicitationItem', foreign_key: :purchase_solicitation_item_id

  has_one :purchase_solicitation, :through => :item
end
