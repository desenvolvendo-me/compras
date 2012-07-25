class PriceCollectionLot < Compras::Model
  attr_accessible :price_collection_id, :observations, :items_attributes

  belongs_to :price_collection

  has_many :items, :class_name => 'PriceCollectionLotItem', :dependent => :destroy, :order => :id
  has_many :price_collection_proposals, :through => :price_collection
  has_many :price_collection_classifications, :as => :classifiable, :dependent => :destroy

  delegate :annulled?, :to => :price_collection, :allow_nil => true

  accepts_nested_attributes_for :items, :allow_destroy => true

  validates :items, :no_duplication => :material_id
  validate :must_have_at_least_one_item

  protected

  def must_have_at_least_one_item
    if items.reject(&:marked_for_destruction?).empty?
      errors.add(:items, :must_have_at_least_one_item)
    end
  end
end
