class ResourceAnnul < Compras::Model
  include Annullable
  belongs_to :annullable, :polymorphic => true

  validates :annullable, :presence => true

  delegate :provider, :price_collection, :to => :annullable, :allow_nil => true
end
