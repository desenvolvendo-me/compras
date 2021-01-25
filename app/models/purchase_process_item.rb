class PurchaseProcessItem < Compras::Model
  attr_accessible :material_id, :quantity, :unit_price, :lot, :additional_information,
                  :creditor_id, :creditor_proposals_attributes, :estimated_value, :max_value,
                  :benefit_type

  attr_accessor :order

  attr_modal :material, :quantity, :unit_price

  auto_increment :item_number, by: [:licitation_process_id, :lot]

  belongs_to :material
  belongs_to :licitation_process
  belongs_to :creditor
  has_many :licitation_process_ratification_items

  has_many :bidder_proposals
  has_many :licitation_process_classifications, :as => :classifiable, :dependent => :destroy
  has_many :creditor_proposals, dependent: :destroy, class_name: 'PurchaseProcessCreditorProposal',
    source: :purchase_process_creditor_proposals
  has_many :purchase_process_accreditation_creditors, through: :purchase_process_accreditation

  has_one  :purchase_process_accreditation, through: :licitation_process
  has_one  :ratification_item, class_name: 'LicitationProcessRatificationItem', dependent: :restrict
  has_one  :material_class, through: :material

  accepts_nested_attributes_for :creditor_proposals

  delegate :reference_unit, :description, :code, :to => :material, :allow_nil => true
  delegate :simplified_processes?, :judgment_form_item?, :to => :licitation_process, :allow_nil => true
  delegate :unit_price, :total_price, to: :ratification_item, allow_nil: true, prefix: true

  validates :material, :quantity, :lot, :presence => true

  orderize "id DESC"
  filterize

  scope :orderize_by_material_description, joins { material }.order { material.description }

  scope :licitation_process_id, lambda { |licitation_process_id|
    where { |item| item.licitation_process_id.eq(licitation_process_id) }
  }

  scope :creditor_id, lambda { |creditor_id|
    where { |item| item.creditor_id.eq(creditor_id) }
  }

  scope :lot, lambda { |lot|
    where { |item| item.lot.eq(lot) }
  }

  scope :ratification_creditor_id, ->(creditor_id) do
    joins { ratification_item.creditor }.
    where { ratification_item.creditor.id.eq(creditor_id) }
  end

  def self.lots
    pluck(:lot).uniq
  end

  def to_s
    material.to_s
  end

  def unit_price_round
    (unit_price).round(3)
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

  def total_price
    unit_price * quantity
  end

  def creditor_winner(purchase_process_item_winner = PurchaseProcessItemWinner)
    purchase_process_item_winner.winner(self)
  end
end
