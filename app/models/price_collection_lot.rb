class PriceCollectionLot < Compras::Model
  attr_accessible :price_collection_id, :observations, :items_attributes

  belongs_to :price_collection

  has_many :items, :class_name => 'PriceCollectionLotItem', :dependent => :destroy, :order => :id
  has_many :price_collection_proposals, :through => :price_collection
  has_many :price_collection_classifications, :as => :classifiable, :dependent => :destroy

  delegate :annulled?, :to => :price_collection, :allow_nil => true

  accepts_nested_attributes_for :items, :allow_destroy => true

  validate :must_have_at_least_one_item
  validate :cannot_have_duplicated_materials

  protected

  def must_have_at_least_one_item
    if items.reject(&:marked_for_destruction?).empty?
      errors.add(:items, :must_have_at_least_one_item)
    end
  end

  def cannot_have_duplicated_materials
   single_materials = []

   items.reject(&:marked_for_destruction?).each do |item|
     if single_materials.include?(item.material_id)
       errors.add(:items)
       item.errors.add(:material_id, :taken)
     end
     single_materials << item.material_id
   end
  end
end
