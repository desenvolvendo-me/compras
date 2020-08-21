class ListPurchaseSolicitation < Compras::Model
  attr_accessible :licitation_process_id, :purchase_solicitation_id

  belongs_to :licitation_process
  belongs_to :purchase_solicitation

  orderize "id DESC"
  filterize

end
