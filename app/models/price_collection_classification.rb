class PriceCollectionClassification < Compras::Model
  attr_accessible :classifiable, :classification, :lot, :total_value,
    :unit_value, :price_collection_proposal

  belongs_to :price_collection_proposal
  belongs_to :classifiable, :polymorphic => true

  delegate :lot_item, :reference_unit, :brand, :quantity, :description, :items, :to => :classifiable, :allow_nil => true

  scope :by_lot, lambda { |lot|
    where { |query| query.lot.eq lot }
  }

  scope :by_price_collection_proposal, lambda { |proposal|
    where { price_collection_proposal_id.eq proposal }
  }

  orderize
  filterize

  def disqualified?
    classification == -1
  end
end
