class PurchaseProcessItem < Compras::Model
  attr_accessible :material_id, :quantity, :unit_price, :lot, :additional_information,
                  :creditor_id, :creditor_proposals_attributes

  attr_accessor :order

  attr_modal :material, :quantity, :unit_price

  belongs_to :material
  belongs_to :licitation_process
  belongs_to :creditor

  has_many :bidder_proposals
  has_many :licitation_process_classifications, :as => :classifiable, :dependent => :destroy
  has_many :creditor_proposals, dependent: :destroy, class_name: 'PurchaseProcessCreditorProposal',
    source: :purchase_process_creditor_proposals
  has_many :purchase_process_accreditation_creditors, through: :purchase_process_accreditation

  has_one  :purchase_process_accreditation, through: :licitation_process

  accepts_nested_attributes_for :creditor_proposals

  delegate :reference_unit, :description, :code, :to => :material, :allow_nil => true
  delegate :direct_purchase?, :to => :licitation_process, :allow_nil => true

  validates :material, :quantity, :lot, :presence => true
  validates :creditor, presence: true, if: :direct_purchase?

  orderize "id DESC"
  filterize

  scope :lots, lambda { pluck(:lot).uniq }

  scope :licitation_process_id, lambda { |licitation_process_id|
    where { |item| item.licitation_process_id.eq(licitation_process_id) }
  }

  scope :creditor_id, lambda { |creditor_id|
    where { |item| item.creditor_id.eq(creditor_id) }
  }

  def to_s
    material.to_s
  end

  def estimated_total_price
    (quantity || BigDecimal(0)) * (unit_price || BigDecimal(0))
  end

  def bidder_proposal?(bidder)
    bidder_proposals.where { bidder_id.eq(bidder.id) }.any?
  end

  def unit_price_by_bidder(bidder)
    first = bidder.proposals.select { |item| item.purchase_process_item == self }.first

    first.nil? ? BigDecimal(0) : first.unit_price
  end

  def total_value_by_bidder(bidder)
    (unit_price_by_bidder(bidder) || BigDecimal(0)) * quantity
  end

  def winning_bid
    licitation_process_classifications.detect { |classification| classification.situation == SituationOfProposal::WON}
  end
end
