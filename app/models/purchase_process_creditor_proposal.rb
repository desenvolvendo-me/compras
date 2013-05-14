class PurchaseProcessCreditorProposal < Compras::Model
  attr_accessible :creditor_id, :brand, :unit_price, :item_id, :delivery_date,
                  :licitation_process_id, :lot

  belongs_to :creditor
  belongs_to :licitation_process
  belongs_to :item, class_name: 'PurchaseProcessItem', foreign_key: :purchase_process_item_id

  has_one :judgment_form, through: :licitation_process

  delegate :lot, :additional_information, :quantity, :reference_unit, :material,
    to: :item, allow_nil: true, prefix: true
  delegate :name, :cnpj, :benefited, to: :creditor, allow_nil: true, prefix: true

  validates :creditor, :licitation_process, :unit_price, presence: true
  validates :lot, :ranking, numericality: { allow_blank: true }
  validates :brand, presence: true, if: :item?

  after_save :update_ranking

  scope :by_creditor_id, lambda { |creditor_id|
    where { |proposal| proposal.creditor_id.eq(creditor_id) }
  }

  scope :by_item_id, lambda { |item_id|
    where { purchase_process_item_id.eq(item_id) }
  }

  scope :find_brothers, lambda { |creditor_proposal|
    where { purchase_process_item_id.eq(creditor_proposal.purchase_process_item_id) &
            lot.eq(creditor_proposal.lot) &
            licitation_process_id.eq(creditor_proposal.licitation_process_id) }.
    order { unit_price }
  }

  orderize
  filterize

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

  private

  def update_ranking
    PurchaseProcessCreditorProposalRanking.rank! self
  end
end
