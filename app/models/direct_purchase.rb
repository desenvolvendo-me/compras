class DirectPurchase < ActiveRecord::Base
  attr_accessible :year, :date, :legal_reference_id, :modality, :provider_id, :organogram_id
  attr_accessible :licitation_object_id, :delivery_location_id, :employee_id, :payment_method_id
  attr_accessible :price_collection, :price_registration, :observation

  attr_modal :year, :date, :modality

  has_enumeration_for :modality, :create_helpers => true, :with => DirectPurchaseModality

  belongs_to :legal_reference
  belongs_to :provider
  belongs_to :organogram
  belongs_to :licitation_object
  belongs_to :delivery_location
  belongs_to :employee
  belongs_to :payment_method

  validates :year, :mask => "9999"

  orderize :year
  filterize

  def to_s
    id.to_s
  end
end
