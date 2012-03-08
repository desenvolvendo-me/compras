class DirectPurchase < ActiveRecord::Base
  attr_accessible :year, :date, :legal_reference_id, :modality, :provider_id, :organogram_id
  attr_accessible :licitation_object_id, :delivery_location_id, :employee_id, :payment_method_id
  attr_accessible :price_collection, :price_registration, :observation, :period_id
  attr_accessible :direct_purchase_items_attributes, :status

  attr_modal :year, :date, :modality

  has_enumeration_for :modality, :create_helpers => true, :with => DirectPurchaseModality
  has_enumeration_for :status, :with => DirectPurchaseStatus

  belongs_to :legal_reference
  belongs_to :provider
  belongs_to :organogram
  belongs_to :licitation_object
  belongs_to :delivery_location
  belongs_to :employee
  belongs_to :payment_method
  belongs_to :period

  has_many :direct_purchase_items, :dependent => :destroy, :inverse_of => :direct_purchase, :order => :id

  accepts_nested_attributes_for :direct_purchase_items, :reject_if => :all_blank, :allow_destroy => true

  validates :year, :mask => "9999"
  validates :status, :presence => true

  validate :cannot_have_more_than_once_item_with_the_same_material

  orderize :year
  filterize

  def to_s
    id.to_s
  end

  def items_total_value
    direct_purchase_items.collect { |item| item.estimated_total_price || 0 }.sum
  end

  protected

  def cannot_have_more_than_once_item_with_the_same_material
    single_materials = []

    direct_purchase_items.each do |item|
      if single_materials.include?(item.material_id)
        errors.add(:direct_purchase_items)
        item.errors.add(:material_id, :taken)
      end
      single_materials << item.material_id
    end
  end
end
