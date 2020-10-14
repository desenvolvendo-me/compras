class ListPurchaseSolicitation < Compras::Model
  attr_accessible :licitation_process_id, :purchase_solicitation_id#,:department_id

  belongs_to :licitation_process
  belongs_to :purchase_solicitation
  # belongs_to :department

  orderize "id DESC"
  filterize

end
