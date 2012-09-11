class PriceRegistrationItem < Compras::Model
  attr_accessible :price_registration_id,
                  :administrative_process_budget_allocation_item_id,
                  :price_registration_budget_structures_attributes

  belongs_to :price_registration
  belongs_to :administrative_process_budget_allocation_item

  has_many :price_registration_budget_structures, :dependent => :destroy, :inverse_of => :price_registration_item, :order => :id

  accepts_nested_attributes_for :price_registration_budget_structures, :allow_destroy => true

  validates :price_registration, :administrative_process_budget_allocation_item,
            :presence => true

  def to_s
    administrative_process_budget_allocation_item.to_s
  end
end
