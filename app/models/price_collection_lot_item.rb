class PriceCollectionLotItem < Compras::Model
  attr_accessible :price_collection_lot_id, :material_id, :brand, :quantity

  belongs_to :price_collection_lot
  belongs_to :material

  has_many :price_collection_proposal_items, :dependent => :destroy
  has_many :price_collection_classifications, :as => :classifiable, :dependent => :destroy

  delegate :reference_unit, :description, :to => :material, :allow_nil => true
  delegate :creditor, :total_price, :to => :winner_proposal, :allow_nil => true, :prefix => true
  delegate :annulled?, :to => :price_collection_lot, :allow_nil => true

  after_initialize :set_default_values

  validates :material, :quantity, :presence => true
  validates :quantity, :numericality => { :greater_than_or_equal_to => 1 }

  def unit_price_by_proposal(proposal)
    proposal.items.select { |item| item.price_collection_lot_item == self }.first.unit_price
  end

  def total_value_by_proposal(proposal)
    (unit_price_by_proposal(proposal) || 0) * quantity
  end

  def proposal_items
    PriceCollectionProposalItem.by_item_order_by_unit_price(id)
  end

  private

  def set_default_values
    self.quantity ||= 0
  end
end
