class PurchaseSolicitationMaterial < Compras::Model
  belongs_to :purchase_solicitation
  belongs_to :material
  # attr_accessible :title, :body
end
