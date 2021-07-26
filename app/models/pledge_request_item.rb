class PledgeRequestItem < Compras::Model
  include BelongsToResource

  attr_accessible :pledge_request_id, :purchase_process_item_id,
                  :accounting_cost_center_id, :quantity, :purchase_solicitation_id,
                  :material_id

  belongs_to :purchase_solicitation
  belongs_to :material
  belongs_to :pledge_request
  belongs_to :purchase_process_item

end
