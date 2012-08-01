class PurchaseSolicitationItemGroupMaterialPurchaseSolicitation < Compras::Model
  self.table_name = :compras_item_group_material_purchase_solicitations

  attr_accessible :purchase_solicitation_item_group_material_id,
                  :purchase_solicitation_id

  belongs_to :purchase_solicitation_item_group_material
  belongs_to :purchase_solicitation

  validates :purchase_solicitation_item_group_material,
            :purchase_solicitation, :presence => true
end
