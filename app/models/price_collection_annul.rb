class PriceCollectionAnnul < ActiveRecord::Base
  include Annullable
  belongs_to :price_collection

  attr_accessible :annul_type, :price_collection_id

  validates :price_collection, :annul_type, :presence => true

  has_enumeration_for :annul_type, :with => PriceCollectionAnnulType, :create_helpers => true
end
