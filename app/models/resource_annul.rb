class ResourceAnnul < Compras::Model
  include Annullable
  attr_accessible :annullable_id, :annullable_type

  belongs_to :annullable, :polymorphic => true

  validates :annullable, :presence => true

  delegate :creditor, :price_collection, :to => :annullable, :allow_nil => true
  delegate :to_s, :annulled?, :to => :annullable, :allow_nil => true

  def purchase_solicitation_ids
    annullable.purchase_solicitation_ids if annullable.respond_to?(:purchase_solicitation_ids)
  end
end
