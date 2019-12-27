class PledgeRequestItem < Compras::Model
  include BelongsToResource

  attr_accessible :pledge_request_id, :purchase_process_item_id,
                  :accounting_cost_center_id, :quantity, :purchase_solicitation_id,
                  :material_id

  belongs_to :purchase_solicitation
  belongs_to :material
  belongs_to :pledge_request
  belongs_to :purchase_process_item

  # belongs_to_resource :accounting_cost_center
  #
  # delegate :ratification_item_unit_price, to: :purchase_process_item,
  #   allow_nil: true
  # delegate :lot, :item_number, :quantity, :additional_information,
  #   to: :purchase_process_item, allow_nil: true, prefix: true
  # delegate :to_s, to: :accounting_cost_center, allow_nil: true, prefix: true
  #
  # validates :purchase_process_item, :quantity, presence: true
  #
  # def estimated_total_price
  #   quantity * ratification_item_unit_price
  # end

end
