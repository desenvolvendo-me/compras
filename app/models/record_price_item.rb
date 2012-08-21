class RecordPriceItem < Compras::Model
  attr_accessible :record_price_id,
                  :administrative_process_budget_allocation_item_id,
                  :record_price_budget_structures_attributes

  belongs_to :record_price
  belongs_to :administrative_process_budget_allocation_item

  has_many :record_price_budget_structures, :dependent => :destroy, :inverse_of => :record_price_item, :order => :id

  accepts_nested_attributes_for :record_price_budget_structures, :allow_destroy => true

  validates :record_price, :administrative_process_budget_allocation_item,
            :presence => true

  def to_s
    administrative_process_budget_allocation_item.to_s
  end
end
