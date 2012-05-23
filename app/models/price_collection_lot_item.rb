class PriceCollectionLotItem < ActiveRecord::Base
  attr_accessible :price_collection_lot_id, :material_id, :brand, :quantity

  belongs_to :price_collection_lot
  belongs_to :material

  delegate :reference_unit, :to => :material, :allow_nil => true

  validates :material, :quantity, :brand, :presence => true
  validates :quantity, :numericality => { :greater_than_or_equal_to => 1 }
end
