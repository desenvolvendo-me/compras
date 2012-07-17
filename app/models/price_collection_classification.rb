class PriceCollectionClassification < Compras::Model
  attr_accessible :classifiable, :classification
  attr_accessible :total_value, :unit_value, :creditor, :creditor_id

  belongs_to :creditor
  belongs_to :classifiable, :polymorphic => true

  delegate :lot_item, :reference_unit, :brand, :quantity, :description, :items, :to => :classifiable, :allow_nil => true

  orderize
  filterize

  def self.by_price_classification_or_lot_or_item(price_collection_id, lots_ids, items_ids)
    where { (classifiable_type.eq('PriceCollection') & classifiable_id.eq(price_collection_id)) |
            (classifiable_type.eq('PriceCollectionLotItem') & classifiable_id.in(items_ids)) |
            (classifiable_type.eq('PriceCollectionLot') & classifiable_id.in(lots_ids)) }
  end
end
