class PurchaseSolicitationItemGroupPurchaseSolicitation < Compras::Model
  attr_accessible :purchase_solicitation_item_group_id, :purchase_solicitation_id

  belongs_to :purchase_solicitation_item_group
  belongs_to :purchase_solicitation

  validates :purchase_solicitation, :purchase_solicitation_item_group, :presence => true
end
