class RealignmentPrice < Compras::Model
  attr_accessible :purchase_process_id, :creditor_id, :lot, :items_attributes

  belongs_to :purchase_process, class_name: 'LicitationProcess'
  belongs_to :creditor

  has_many :items, class_name: 'RealignmentPriceItem', dependent: :destroy,
    inverse_of: :realignment_price, order: :id

  accepts_nested_attributes_for :items, allow_destroy: true

  delegate :judgment_form_lot?, :trading?, to: :purchase_process, allow_nil: true

  validates :purchase_process_id, uniqueness: { scope: [:creditor_id, :lot] }, allow_blank: true
  validate :total_value_validation

  scope :purchase_process_id, ->(purchase_process_id) do
    where { |query| query.purchase_process_id.eq purchase_process_id }
  end

  scope :creditor_id, ->(creditor_id) do
    where { |query| query.creditor_id.eq creditor_id }
  end

  scope :lot, ->(lot) do
    where { |query| query.lot.eq lot }
  end

  def purchase_process_items
    if judgment_form_lot?
       purchase_process.items.lot(lot)
    else
      purchase_process.items
    end
  end

  def total_value
    if judgment_form_lot?
      if trading?
        total_value_lot_trading
      else
        total_value_lot_proposal
      end
    else
      total_value_global
    end
  end

  private

  def total_value_lot_trading
    purchase_process.
      trading_items.
      lot(lot).
      sum(&:amount_winner)
  end

  def total_value_lot_proposal
    purchase_process.
      creditor_proposals.
      creditor_id(creditor_id).
      by_lot(lot).
      sum(&:unit_price)
  end

  def total_value_global
    purchase_process.
      creditor_proposals.
      creditor_id(creditor_id).
      sum(&:unit_price)
  end

  def total_value_validation
    if total_value != items.to_a.sum(&:total_price)
      errors.add(:base, :the_sum_of_item_prices_should_be_equal_to_proposal)
    end
  end
end
