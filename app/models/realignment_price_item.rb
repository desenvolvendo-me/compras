class RealignmentPriceItem < Compras::Model
  attr_accessible :price, :brand, :delivery_date, :purchase_process_item_id,
    :realignment_price_id

  belongs_to :realignment_price
  belongs_to :item, class_name: 'PurchaseProcessItem',
    foreign_key: :purchase_process_item_id

  has_one :creditor, through: :realignment_price
  has_one :material, through: :item
  has_one :purchase_process, through: :realignment_price

  has_many :creditor_proposals, through: :purchase_process

  validates :price, presence: true

  delegate :judgment_form_lot?,
    to: :purchase_process, allow_nil: true
  delegate :year, :process,
    to: :purchase_process, allow_nil: true, prefix: true
  delegate :identity_document,
    to: :creditor, allow_nil: true, prefix: true
  delegate :reference_unit, :code, :description,
    to: :material, allow_nil: true, prefix: true
  delegate :lot,
    to: :item, allow_nil: true

  orderize :id

  scope :purchase_process_id, ->(purchase_process_id) do
    joins { realignment_price }.
    where { realignment_price.purchase_process_id.eq purchase_process_id }
  end

  scope :creditor_id, ->(creditor_id) do
    joins { realignment_price }.
    where { realignment_price.creditor_id.eq creditor_id }
  end

  scope :lot, ->(lot) do
    joins { realignment_price }.
    where { realignment_price.lot.eq lot }
  end

  def total_price
    quantity * price
  end

  def quantity
    item.try(:quantity) || BigDecimal(0)
  end
end
