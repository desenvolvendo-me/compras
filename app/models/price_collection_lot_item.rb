class PriceCollectionLotItem < Compras::Model
  attr_accessible :price_collection_lot_id, :material_id, :brand, :quantity

  belongs_to :price_collection_lot
  belongs_to :material

  has_many :price_collection_proposal_items, :dependent => :destroy
  has_many :price_collection_classifications, :as => :classifiable, :dependent => :destroy

  delegate :reference_unit, :description, :to => :material, :allow_nil => true
  delegate :creditor, :total_price, :to => :winner_proposal, :allow_nil => true, :prefix => true
  delegate :annulled?, :to => :price_collection_lot, :allow_nil => true

  validates :material, :quantity, :presence => true
  validates :quantity, :numericality => { :greater_than_or_equal_to => 1 }

  def unit_price_by_price_collection_and_creditor(price_collection, creditor)
    proposal = price_collection.price_collection_proposals.select { |p| p.creditor == creditor }.first

    proposal.items.select { |item| item.price_collection_lot_item == self }.first.unit_price
  end

  def total_value_by_price_collection_and_creditor(price_collection, creditor)
    unit_price_by_price_collection_and_creditor(price_collection, creditor) * quantity
  end
end
