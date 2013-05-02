class PurchaseProcessCreditorProposal < Compras::Model
  attr_accessible :creditor_id, :brand, :unit_price, :item_id, :delivery_term,
                  :licitation_process_id, :lot

  belongs_to :creditor
  belongs_to :licitation_process
  belongs_to :item, class_name: 'PurchaseProcessItem', foreign_key: :purchase_process_item_id

  has_one :judgment_form, through: :licitation_process

  delegate :lot, :additional_information, :quantity, :reference_unit, :material,
    to: :item, allow_nil: true, prefix: true

  validates :creditor, :licitation_process, :unit_price, presence: true
  validates :lot, numericality: { allow_blank: true }
  validates :brand, presence: true, if: :item?

  scope :by_creditor_and_licitation_process, lambda { |creditor, licitation_process|
    where(creditor_id: creditor, licitation_process_id: licitation_process) }

  def total_price
    (unit_price || 0) * (item_quantity || 1)
  end

  def qualify!
    update_attribute(:disqualified, false)
  end

  def disqualify!
    update_attribute(:disqualified, true)
  end

  def item?
    return false unless judgment_form
    judgment_form.item?
  end
end
