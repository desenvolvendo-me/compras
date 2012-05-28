class PriceCollectionLotItem < ActiveRecord::Base
  attr_accessible :price_collection_lot_id, :material_id, :brand, :quantity

  belongs_to :price_collection_lot
  belongs_to :material

  has_many :price_collection_proposal_items, :dependent => :destroy

  delegate :reference_unit, :description, :to => :material, :allow_nil => true
  delegate :provider, :total_price, :to => :winner_proposal, :allow_nil => true, :prefix => true

  validates :material, :quantity, :brand, :presence => true
  validates :quantity, :numericality => { :greater_than_or_equal_to => 1 }

  def winner_proposal(classificator = PriceCollectionProposalsClassificatorByItem)
    classificator.new(self).winner_proposal
  end
end
