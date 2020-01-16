class BalanceAdjustment < Compras::Model
  attr_accessible :observation, :licitation_process_id, :contract_id, :purchase_solicitation_id

  belongs_to :licitation_process
  belongs_to :contract
  belongs_to :purchase_solicitation

  orderize "id DESC"
  filterize
end
