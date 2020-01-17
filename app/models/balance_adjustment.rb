class BalanceAdjustment < Compras::Model
  attr_accessible :observation, :licitation_process_id, :contract_id, :purchase_solicitation_id,
                  :items_attributes

  belongs_to :licitation_process
  belongs_to :contract
  belongs_to :purchase_solicitation
  has_many :items, class_name: 'BalanceAdjustmentItem', dependent: :destroy

  accepts_nested_attributes_for :items, allow_destroy: true

  orderize "id DESC"
  filterize
end
