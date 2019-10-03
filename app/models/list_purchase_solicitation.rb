class ListPurchaseSolicitation < Compras::Model
  belongs_to :licitation_process
  belongs_to :purchase_solicitation
  attr_accessible :balance, :consumed_value, :expected_value,
                  :resource_source,:licitation_process_id,
                  :purchase_solicitation_id

  orderize "id DESC"
  filterize

end
