class PurchaseProcessCreditorProposal < Compras::Model
  attr_accessible :creditor_id, :brand, :unit_price, :old_unit_price,
    :item_id, :delivery_date, :licitation_process_id, :lot, :ranking,
    :purchase_process_item_id, :model_version

  belongs_to :creditor
  belongs_to :licitation_process
  belongs_to :item, class_name: 'PurchaseProcessItem', foreign_key: :purchase_process_item_id

  has_one :judgment_form, through: :licitation_process
  has_one :material, through: :item
  has_one :licitation_process_ratifications, through: :licitation_process

  has_many :bidders, through: :licitation_process

  delegate :code, :description, :reference_unit,
    to: :material, prefix: true, allow_nil: true
  delegate :lot, :additional_information, :quantity,
    to: :item, prefix: true, allow_nil: true
  delegate :name, :cnpj, :benefited, :identity_document,
    to: :creditor, allow_nil: true, prefix: true
  delegate :year, :process, :trading?,
    to: :licitation_process, allow_nil: true, prefix: true

  validates :creditor, :licitation_process, :unit_price, presence: true
  validates :lot, :ranking, numericality: { allow_blank: true }
  validates :unit_price, numericality: { greater_than: 0, if: :should_validate_unit_price? }
  validates :brand, presence: true, if: :should_validate_brand_presence?
  validates :ranking, presence: true, if: :ranking_changed?

  validate :unit_price_is_lower_than_best_proposal, if: :benefited_tied?

  before_update :reset_old_unit_price, if: :should_reset_old_unit_price?
  after_save :update_ranking, unless: :ranking_changed?

  orderize :id
  filterize

  scope :unit_price_equal, ->(price) {
    where { unit_price.eq price }
  }

  scope :unit_price_greater_than, ->(price){
    where { unit_price.gt price}
  }

  scope :licitation_process_id, lambda { |licitation_process_id|
    where { |proposal| proposal.licitation_process_id.eq(licitation_process_id) }
  }

  scope :type_of_purchase_licitation, -> { joins { licitation_process }.
    where { licitation_process.type_of_purchase.eq(PurchaseProcessTypeOfPurchase::LICITATION) }
  }

  scope :creditor_id, lambda { |creditor_id|
    where { |proposal| proposal.creditor_id.eq(creditor_id) }
  }

  scope :by_item_id, lambda { |item_id|
    where { purchase_process_item_id.eq(item_id) }
  }

  scope :by_lot, lambda { |lot|
    where { |proposal| proposal.lot.eq(lot) }
  }

  scope :find_brothers, lambda { |creditor_proposal|
    where { purchase_process_item_id.eq(creditor_proposal.purchase_process_item_id) &
            lot.eq(creditor_proposal.lot) &
            licitation_process_id.eq(creditor_proposal.licitation_process_id) }.
    order { unit_price }
  }

  scope :find_brothers_for_ranking_with_bidder_enabled, lambda { |creditor_proposal|
    find_brothers_for_ranking(creditor_proposal).
    joins { bidders }.
    where { '"compras_bidders"."creditor_id" = "compras_purchase_process_creditor_proposals"."creditor_id"' }.
    where { bidders.enabled.eq(true) }
  }

  scope :find_brothers_for_ranking, lambda { |creditor_proposal|
    find_brothers(creditor_proposal).
    where { disqualified.eq(false) }
  }

  scope :winning_proposals, lambda { where { ranking.eq 1 }.order { creditor_id } }

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

  scope :proposal_by_creditor, lambda{|creditorId|
    where{disqualified.eq(false) & creditor_id.eq(creditorId)}
  }

  def self.best_proposal_for(creditor_proposal)
    if creditor_proposal.licitation_process.trading?
      find_brothers_for_ranking(creditor_proposal).first
    else
      find_brothers_for_ranking_with_bidder_enabled(creditor_proposal).first
    end
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

  def realignment_items(realignment_price_item_repository = RealignmentPriceItem)
    return [] if judgment_form.item?

    realignment_price_item_repository.
      purchase_process_id(licitation_process_id).
      creditor_id(creditor_id).
      lot(lot)
  end

  private

  def should_validate_brand_presence?
    return false unless item?
    (unit_price || 0) > 0
  end

  def should_validate_unit_price?
    return false unless item?
    brand.present?
  end

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

  def should_reset_old_unit_price?
    !old_unit_price_changed? && unit_price_changed?
  end

  def reset_old_unit_price
    write_attribute :old_unit_price, nil
  end
end
