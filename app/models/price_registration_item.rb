class PriceRegistrationItem < Compras::Model
  attr_accessible :price_registration_id,
                  :administrative_process_budget_allocation_item_id,
                  :price_registration_budget_structures_attributes

  belongs_to :price_registration
  belongs_to :administrative_process_budget_allocation_item

  has_many :price_registration_budget_structures, :dependent => :destroy, :inverse_of => :price_registration_item, :order => :id

  accepts_nested_attributes_for :price_registration_budget_structures, :allow_destroy => true

  delegate :quantity, :reference_unit, :licitation_process_lot,
           :to => :administrative_process_budget_allocation_item, :allow_nil => true
  delegate :type_of_calculation, :licitation_process, :to => :price_registration

  validates :price_registration, :administrative_process_budget_allocation_item,
            :presence => true

  def to_s
    administrative_process_budget_allocation_item.to_s
  end

  def unit_price
    winning_bid.unit_value if winning_bid
  end

  def winning_bidder
    winning_bid.bidder if winning_bid
  end

  def winning_bid
    if type_of_calculation == PriceCollectionTypeOfCalculation::LOWEST_GLOBAL_PRICE
      licitation_process.winning_bid
    elsif type_of_calculation == PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM
      administrative_process_budget_allocation_item.winning_bid
    elsif type_of_calculation == PriceCollectionTypeOfCalculation::LOWEST_PRICE_BY_LOT
      licitation_process_lot.winning_bid
    end
  end

  def balance
    quantity - purchased_quantity if quantity
  end
end
