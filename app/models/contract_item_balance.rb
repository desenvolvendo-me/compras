class ContractItemBalance < Compras::Model
  attr_accessible :purchase_process_id, :purchase_solicitation_id, :contract_id,
                  :creditor_id, :material_id, :contract_balance, :quantity_type,
                  :movable_id, :movable_type

  has_enumeration_for :quantity_type

  belongs_to :purchase_process, class_name: 'LicitationProcess'
  belongs_to :purchase_solicitation
  belongs_to :contract
  belongs_to :creditor
  belongs_to :material
  belongs_to :movable, polymorphic: true

end