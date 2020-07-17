class PurchaseSolicitationObject < Compras::Model
  attr_accessible :purchase_solicitation_id, :management_object_id

  belongs_to :purchase_solicitation
  belongs_to :management_object

  orderize "id DESC"
  filterize

  validates :purchase_solicitation_id,  presence: true

end
