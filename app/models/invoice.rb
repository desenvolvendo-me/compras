class Invoice < Compras::Model
  attr_accessible :number, :release_date, :date, :value, :supply_order_item_invoices_attributes,
                  :competence_month, :settling_date, :settling_number

  belongs_to :supply_order
  has_many :supply_order_item_invoices, dependent: :destroy

  validates :number, presence: true

  accepts_nested_attributes_for :supply_order_item_invoices, allow_destroy: true, reject_if: proc { |att| att['quantity_supplied'].blank?}

end
