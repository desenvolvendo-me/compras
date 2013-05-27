class PurchaseProcessCreditorProposal < Compras::Model
  attr_accessible :creditor_id, :brand, :unit_price, :item_id, :delivery_date,
                  :licitation_process_id, :lot, :ranking, :realigment_prices_attributes

  attr_accessor :difference_price

  belongs_to :creditor
  belongs_to :licitation_process
  belongs_to :item, class_name: 'PurchaseProcessItem', foreign_key: :purchase_process_item_id

  has_one :judgment_form, through: :licitation_process
  has_one :material, through: :item
  has_one :licitation_process_ratifications, through: :licitation_process

  has_many :realigment_prices, dependent: :destroy

  accepts_nested_attributes_for :realigment_prices, allow_destroy: true

  delegate :code, :description, :reference_unit,
    to: :material, prefix: true, allow_nil: true
  delegate :lot, :additional_information, :quantity,
    to: :item, prefix: true, allow_nil: true
  delegate :name, :cnpj, :benefited, :identity_document,
    to: :creditor, allow_nil: true, prefix: true
  delegate :execution_unit_responsible, :year, :process,
    to: :licitation_process, allow_nil: true, prefix: true

  validates :creditor, :licitation_process, :unit_price, presence: true
  validates :lot, :ranking, numericality: { allow_blank: true }
  validates :brand, presence: true, if: :item?

  validates :ranking, presence: true, if: :ranking_changed?
  after_save :update_ranking, unless: :ranking_changed?

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

  scope :winning_proposals, where { ranking.eq 1 }.order { creditor_id }

  scope :by_ratification_month_and_year, lambda { |month, year|
    joins { licitation_process_ratifications }.
    where(%{
      extract(month from compras_licitation_process_ratifications.ratification_date) = ? AND
      extract(year from compras_licitation_process_ratifications.ratification_date) = ?},
      month, year)
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

  def qualified?
    !disqualified?
  end

  def reset_ranking!
    update_column :ranking, 0
  end

  def item_or_lot_or_purchase_process
    item || lot || licitation_process
  end

  def available_rankings
    first = cheaper_brothers.size + 1
    last  = same_price_brothers.size + first

    (first...last).to_a
  end

  def cheaper_brothers
    PurchaseProcessCreditorProposal.find_brothers(self).where { |query|
      query.unit_price.lt(self.unit_price)
    }
  end

  def same_price_brothers
    PurchaseProcessCreditorProposal.find_brothers(self).where { |query|
      query.unit_price.eq(self.unit_price)
    }
  end

  private

  def update_ranking
    PurchaseProcessCreditorProposalRanking.rank! self
  end
end
