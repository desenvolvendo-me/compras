class PurchaseSolicitationSecretary < Compras::Model
  attr_accessible :secretary_id, :purchase_solicitation_id

  belongs_to :secretary
  belongs_to :purchase_solicitation

  validates :secretary_id, :purchase_solicitation_id, :presence => true

end
