class PriceRegistrationItem < Compras::Model
  attr_accessible :price_registration_id,
                  :administrative_process_budget_allocation_item_id,
                  :price_registration_budget_structures_attributes

  belongs_to :price_registration
  belongs_to :administrative_process_budget_allocation_item

  has_many :price_registration_budget_structures, :dependent => :destroy, :inverse_of => :price_registration_item, :order => :id

  has_one :licitation_process, :through => :price_registration
  has_one :judgment_form, :through => :licitation_process

  accepts_nested_attributes_for :price_registration_budget_structures, :allow_destroy => true

  delegate :quantity, :reference_unit, :licitation_process_lot,
           :to => :administrative_process_budget_allocation_item, :allow_nil => true

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
    if judgment_form.lowest_price? && judgment_form.global?
      licitation_process.winning_bid
    elsif judgment_form.lowest_price? && judgment_form.item?
      administrative_process_budget_allocation_item.winning_bid
    elsif judgment_form.lowest_price? && judgment_form.lot?
      licitation_process_lot.winning_bid
    end
  end

  def balance
    quantity - purchased_quantity if quantity
  end
end
