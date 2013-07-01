class RealignmentPriceItem < Compras::Model
  attr_accessible :price, :brand, :delivery_date, :purchase_process_item_id,
    :realignment_price_id

  belongs_to :realignment_price
  belongs_to :item, class_name: 'PurchaseProcessItem',
    foreign_key: :purchase_process_item_id

  has_one :purchase_process, through: :realignment_price

  validates :price, presence: true

  delegate :judgment_form_lot?, to: :purchase_process, allow_nil: true

  orderize :id

  def total_price
    quantity * price
  end

  def quantity
    item.try(:quantity) || BigDecimal(0)
  end
end
