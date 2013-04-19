class PurchaseProcessCreditorProposal < Compras::Model
  attr_accessible :creditor_id, :brand, :unit_price, :item_id, :creditor_id

  belongs_to :creditor
  belongs_to :item, class_name: 'PurchaseProcessItem',
             foreign_key: :purchase_process_item_id

  has_one :licitation_process, through: :item

  delegate :lot, :additional_information, :quantity, :reference_unit, :material,
    to: :item, allow_nil: true, prefix: true

  validates :creditor, :item, :brand, :unit_price, presence: true

  def total_price
    (unit_price || 0) * (item_quantity || 0)
  end
end
