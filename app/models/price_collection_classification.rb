class PriceCollectionClassification < Compras::Model
  attr_accessible :classifiable, :classification
  attr_accessible :total_value, :unit_value, :price_collection_proposal

  belongs_to :price_collection_proposal
  belongs_to :classifiable, :polymorphic => true

  delegate :lot_item, :reference_unit, :brand, :quantity, :description, :items, :to => :classifiable, :allow_nil => true

  orderize
  filterize
end
