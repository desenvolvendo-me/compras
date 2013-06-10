class PurchaseProcessCreditorProposal < Compras::Model
  attr_accessible :creditor_id, :brand, :unit_price, :old_unit_price,
    :item_id, :delivery_date, :licitation_process_id, :lot, :ranking,
    :realigment_prices_attributes

  attr_accessor :difference_price

  belongs_to :creditor
  belongs_to :licitation_process
  belongs_to :item, class_name: 'PurchaseProcessItem', foreign_key: :purchase_process_item_id

  has_one :judgment_form, through: :licitation_process
  has_one :material, through: :item
  has_one :licitation_process_ratifications, through: :licitation_process

  has_many :realigment_prices, dependent: :destroy
  has_many :bidders, through: :licitation_process

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
  validates :unit_price, numericality: { greater_than: 0 }
  validates :brand, presence: true, if: :item?
  validates :ranking, presence: true, if: :ranking_changed?

  validate :unit_price_is_lower_than_best_proposal, if: :benefited_tied?

  after_save :update_ranking, unless: :ranking_changed?

  orderize
  filterize

  scope :creditor_id, lambda { |creditor_id|
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

  scope :find_brothers_for_ranking, lambda { |creditor_proposal|
    find_brothers(creditor_proposal).
    joins { bidders }.
    where { '"compras_bidders"."creditor_id" = "compras_purchase_process_creditor_proposals"."creditor_id"' }.
    where { bidders.enabled.eq(true) & disqualified.eq(false) }
  }

  scope :winning_proposals, where { ranking.eq 1 }.order { creditor_id }

  scope :by_ratification_month_and_year, lambda { |month, year|
    joins { licitation_process_ratifications }.
    where(%{
      extract(month from compras_licitation_process_ratifications.ratification_date) = ? AND
      extract(year from compras_licitation_process_ratifications.ratification_date) = ?},
      month, year)
  }

  scope :judgment_by_item, lambda {
    joins { judgment_form }.
    where { judgment_form.kind.eq(JudgmentFormKind::ITEM) }
  }

  scope :judgment_by_lot_or_global, lambda {
    joins { judgment_form }.
    where { judgment_form.kind.in([JudgmentFormKind::LOT, JudgmentFormKind::GLOBAL]) }
  }

  def self.best_proposal_for(creditor_proposal)
    find_brothers_for_ranking(creditor_proposal).first
  end

  def total_price
    (unit_price || 0) * (item_quantity || 1)
  end

  def benefited_unit_price
    return unit_price unless creditor.benefited

    best_proposal  = self.class.best_proposal_for(self).unit_price
    max_unit_price = best_proposal + (best_proposal * 0.1)

    if unit_price <= max_unit_price
      return best_proposal
    else
      return unit_price
    end
  end

  def benefited_tied?
    return false unless available_for_benefit?

    if unit_price > benefited_unit_price
      return true
    else
      return false
    end
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

  def tie_ranking!
    update_column :ranking, 0
    update_column :tied, true
  end

  def reset_ranking!
    apply_ranking! -1
  end

  def apply_ranking!(rank)
    update_column :ranking, rank
    update_column :tied, false
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

  def unit_price_is_lower_than_best_proposal
    return unless (unit_price && old_unit_price)

    if unit_price >= best_proposal
      errors.add(:unit_price, :unit_price_should_be_lower_than_old_unit_price)
    end
  end

  def best_proposal
    self.class.best_proposal_for(self).unit_price
  end

  def available_for_benefit?
    unit_price && tied? && creditor && creditor.benefited
  end
end
